# dotfiles

```text
    ,#####    ###    ,#############
   ###  `##  ## ##   ###      ##
  ,##       ##   ##  ######   ##
  ### ##### ######## #####'  ,##
  ###   ######   `#####      ###
  `#########'      ####     ####
```

> ...managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## Bootstrap Machines

### Local

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/bin init kermage --apply
```

### Remote

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init kermage --one-shot
```

#### Setup session

```bash
source gaftenv
```

## Validation

CI runs the bootstrap above on macOS, Linux and Windows runners: the Local command on
all three and the Remote command on Linux, each sourced from the checked-out commit
instead of a clone. The install scripts run too, so a failed install fails the run.
It then asserts through chezmoi itself: `chezmoi verify` and an empty `chezmoi
status`. The remote run excludes scripts from both, because `--one-shot` purges the
record of which scripts ran. A template renders, from `.chezmoidata.yaml`, the
packages each platform's install script installs, and that platform's package manager
(Homebrew, mise or scoop) must report every one of them installed. Last, a shell is
started through the startup files, a zsh login on macOS, a Git Bash login on Windows
and `source gaftenv` on Linux, and must exit 0 with nothing on stderr beyond the few
lines the workflow allows, each with its reason.

Locally, `chezmoi verify` and `chezmoi status`.
