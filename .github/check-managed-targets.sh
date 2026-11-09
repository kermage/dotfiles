#!/usr/bin/env bash
#
# Checks the Managed targets table in docs/ARCHITECTURE.md against what chezmoi
# manages on this OS. chezmoi renders only the running OS's source state, so an
# OS checks only its own rows: those whose Platforms cell is all or names it.
#
# It fails, naming the target, when a row's target is not managed, when its Type
# differs from the one read from chezmoi, or when a managed path is covered by no
# row. A managed path is covered when it is a row's target, a parent directory of
# one, or an external under an external row's target.
#
# Usage: check-managed-targets.sh <chezmoi> <macOS|Linux|Windows>

set -euo pipefail
# comm needs both inputs sorted in the same order.
export LC_ALL=C

if [ $# -ne 2 ]; then
	echo "usage: $0 <chezmoi> <macOS|Linux|Windows>" >&2
	exit 2
fi
chezmoi=$1
os=$2
case "$os" in
	macOS) chezmoi_os=darwin ;;
	Linux) chezmoi_os=linux ;;
	Windows) chezmoi_os=windows ;;
	*)
		echo "unknown OS: $os (want macOS, Linux or Windows)" >&2
		exit 2
		;;
esac

root="$(cd "$(dirname "$0")/.." && pwd)"
doc="$root/docs/ARCHITECTURE.md"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cz() {
	"$chezmoi" --source "$root" "$@" | tr -d '\r'
}

running="$(cz execute-template '{{ .chezmoi.os }}')"
if [ "$running" != "$chezmoi_os" ]; then
	echo "chezmoi renders the $running source state here, not $os's" >&2
	exit 2
fi
dest="$(cz execute-template '{{ .chezmoi.destDir }}')"

# Prints "<target>\t<type>" for this OS's rows, the target relative to the home
# directory. Any row it cannot read fails the whole table, whichever OS it is for.
# shellcheck disable=SC2016 # an awk program, which the shell must not expand
parse='
function fail(msg) {
	printf "docs/ARCHITECTURE.md:%d: %s\n", FNR, msg > "/dev/stderr"
	failed = 1
	exit 1
}
function trim(s) {
	gsub(/^ +| +$/, "", s)
	return s
}
# Splits a table row into cells[1..n] and returns n, or 0 if it is not a row.
function split_row(line, cells,    inner, n, i) {
	if (line !~ /^\|.*\|$/ || length(line) < 2) return 0
	inner = substr(line, 2, length(line) - 2)
	n = split(inner, cells, "|")
	for (i = 1; i <= n; i++) cells[i] = trim(cells[i])
	return n
}
{ sub(/\r$/, "") }
state == "" {
	if ($0 == "## Managed targets") state = "heading"
	next
}
state == "heading" {
	if ($0 ~ /^#+ /) fail("no table under ## Managed targets")
	if ($0 !~ /^\|/) next
	if (split_row($0, cells) != 3 || cells[1] != "Target" || cells[2] != "Type" || cells[3] != "Platforms")
		fail("header is not | Target | Type | Platforms |")
	state = "header"
	next
}
state == "header" {
	n = split_row($0, cells)
	if (n != 3) fail("no delimiter row under the header")
	for (i = 1; i <= n; i++)
		if (cells[i] !~ /^:?-+:?$/) fail("no delimiter row under the header")
	state = "rows"
	next
}
state == "rows" {
	if ($0 !~ /^\|/) exit
	n = split_row($0, cells)
	if (n != 3) fail("row has " n " cells, not 3: " $0)
	if (cells[1] !~ /^`~\/[^`]+`$/) fail("target is not one backticked ~/ path: " cells[1])
	target = substr(cells[1], 4, length(cells[1]) - 4)
	type = cells[2]
	if (type != "file" && type != "directory" && type != "tracked keys" && type != "external")
		fail(cells[1] ": unknown type: " type)
	ours = 0
	if (cells[3] == "all") {
		ours = 1
	} else {
		np = split(cells[3], platforms, ",")
		for (p in named) delete named[p]
		for (i = 1; i <= np; i++) {
			p = trim(platforms[i])
			if (p != "macOS" && p != "Linux" && p != "Windows")
				fail(cells[1] ": unknown platform: " p)
			if (p in named) fail(cells[1] ": platform named twice: " p)
			named[p] = 1
			if (p == os) ours = 1
		}
	}
	rows++
	if (!ours) next
	if (target in seen) fail(cells[1] ": listed twice for " os)
	seen[target] = 1
	print target "\t" type
}
END {
	if (failed) exit 1
	if (state == "") fail("no ## Managed targets heading")
	if (state != "rows") fail("no table under ## Managed targets")
	if (!rows) fail("the Managed targets table has no rows")
}
'
awk -v os="$os" "$parse" "$doc" > "$tmp/rows"

cz managed --exclude=scripts | sort -u > "$tmp/managed"
cz managed --exclude=scripts,externals | sort -u > "$tmp/sourced"
cz managed --include=dirs | sort -u > "$tmp/dirs"
comm -23 "$tmp/managed" "$tmp/sourced" > "$tmp/externals"

failed=0
problem() {
	# shellcheck disable=SC2088 # names the target as the table writes it
	echo "~/$1" >&2
	failed=1
}

while IFS=$'\t' read -r target type; do
	if ! grep -Fxq -- "$target" "$tmp/managed"; then
		problem "$target: in the table for $os, but chezmoi does not manage it"
		continue
	fi
	# External comes first: an external may be a file or a directory, and chezmoi
	# makes up source names for it that exist nowhere in the repo.
	if ! grep -Fxq -- "$target" "$tmp/sourced"; then
		actual="external"
	else
		name="$(cz source-path "$dest/$target")"
		name="${name##*/}"
		name="${name##*\\}"
		case "$name" in
			modify_*) actual="tracked keys" ;;
			create_* | remove_* | symlink_*)
				problem "$target: its source $name is a ${name%%_*} entry, which no Type in the table describes"
				continue
				;;
			*)
				if grep -Fxq -- "$target" "$tmp/dirs"; then
					actual="directory"
				else
					actual="file"
				fi
				;;
		esac
	fi
	if [ "$actual" != "$type" ]; then
		problem "$target: the table says $type, chezmoi says $actual"
	fi
done < "$tmp/rows"

# Covered by a row: its target and every parent directory of it.
awk -F '\t' '{ print $1; p = $1; while (sub(/\/[^\/]*$/, "", p)) print p }' "$tmp/rows" \
	| sort -u > "$tmp/covered"
# Only an external row covers what sits under its target, and only the externals.
awk -F '\t' '$2 == "external" { print $1 }' "$tmp/rows" > "$tmp/external-rows"
awk '
	FILENAME == ARGV[1] { roots[$0] = 1; next }
	{ for (r in roots) if (index($0, r "/") == 1) { print; next } }
' "$tmp/external-rows" "$tmp/externals" >> "$tmp/covered"
sort -u -o "$tmp/covered" "$tmp/covered"

while read -r path; do
	problem "$path: chezmoi manages it on $os, but no row covers it"
done < <(comm -23 "$tmp/managed" "$tmp/covered")

if [ "$failed" -ne 0 ]; then
	echo "docs/ARCHITECTURE.md: the Managed targets table is out of step with chezmoi on $os" >&2
	exit 1
fi
echo "docs/ARCHITECTURE.md: the Managed targets table matches chezmoi on $os"
