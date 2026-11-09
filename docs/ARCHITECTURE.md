# Architecture

What the repo manages on a machine, and how each part is owned.

## Settings files

atuin's and mise's `config.toml` are `modify_` templates that own only their
**tracked keys**, each declared once as a dotted path mapped to its whole value.
Every other key is **machine-owned** and survives apply, so a machine's own
additions, such as atuin's `history_filter` or mise's `trusted_config_paths`, stay
out of the repo. While all tracked keys match, the live file passes through
untouched; on drift, apply resets them and rewrites the whole file with sorted keys
and without TOML comments. The repo wins: a tracked key changed by hand reverts on
the next apply, and `re-add` and `merge` do not work on these targets. On Linux,
mise tracks one `tools` entry per common **listed package** but git, which apt
installs, so a tool added with `mise use -g` stays; elsewhere it tracks none.
Dropping a key from a template leaves it in the live file with its last value;
remove it by hand if needed.
