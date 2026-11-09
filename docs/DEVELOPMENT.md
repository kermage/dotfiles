# Development

Working on the repo itself: how the source state is authored and how changes
are validated.

## Authoring

`.chezmoiroot` points chezmoi at `home/`, so the source state root is `home/` and
everything outside it is repository scaffolding.

chezmoi ignores source-state path components that begin with a literal dot, so a
dot-prefixed target such as `~/.zshrc` is authored with the `dot_` prefix, as
`dot_zshrc`. The `.gitkeep` files that hold empty directories in git, such as the
ones behind `projects`, `Sites` and `.ssh`, are ignored for the same reason, so they
never become targets; the directories do.

`home/.chezmoi.toml.tmpl` is the config template and `home/.chezmoidata.yaml` holds
the template data. `home/.chezmoiignore` picks the install scripts for the running
platform by excluding the `.chezmoiscripts/<os>/` subdirectories that do not match.

## Validation

CI runs the README's Bootstrap Machines commands on macOS, Linux and Windows
runners: the README's Local command on all three and its Remote command on Linux,
each sourced from the checked-out commit instead of a clone. The install scripts run
too, so a failed install fails the run. It then asserts that the target state
matches the source state: `chezmoi verify` and an empty `chezmoi status`. The remote
run excludes scripts from both, because `--one-shot` purges the record of which
scripts ran. The Local command also runs in a lived-in home, seeded first with atuin
and mise settings that hold **machine-owned keys** beside **tracked keys** drifted
from the repo or missing. There the same assertions prove the tracked keys were
reset, and a template checks that every seeded machine-owned key kept its value. A
template renders, from `.chezmoidata.yaml`, the packages each platform's install
script installs, and that platform's package manager (Homebrew, mise or scoop) must
report every one of them installed. Then a shell is started through the startup
files, a zsh login on macOS, a Git Bash login on Windows and `source gaftenv` on
Linux, and must exit 0 with nothing on stderr beyond the few lines the workflow
allows, each with its reason.

Last comes the one hand-written list CI checks: the Managed targets table in
`docs/ARCHITECTURE.md`, held against chezmoi on each OS in the Local command's run
in a fresh home. `.github/check-managed-targets.sh` compares the table's rows for
that OS, those whose Platforms cell is `all` or names it, with `chezmoi managed`. It
fails, naming the target, when a row's target is not managed, when a row's Type
differs from the one read from chezmoi, or when a managed path is covered by no row:
it is neither a row's target, nor a parent directory of one, nor an external under
an `external` row's target. A row it cannot read fails it too, whichever OS the row
is for. The other runs skip it: `chezmoi managed` reads the source state, and no
template reads the bootstrap mode, so they would repeat its answer.

Locally, `chezmoi verify`, `chezmoi status` and
`.github/check-managed-targets.sh chezmoi <OS>`, with `macOS`, `Linux` or `Windows`
as `<OS>`.
