# Architecture

What the repo manages on a machine, and how each part is owned.

## Bootstrap

A **local bootstrap**, the README's Local command, leaves chezmoi set up on the
machine: the binary in `~/bin`, the source checkout in `~/.local/share/chezmoi`, the
config rendered from `home/.chezmoi.toml.tmpl` and the state in `~/.config/chezmoi`,
so later applies pick up changes to the repo. A **remote bootstrap**, the Remote
command, applies with `--one-shot`, which then purges the source checkout, config
and state, and the binary, which the installer put in `./bin`. It keeps none of
them.

The source state renders the same under either: no template reads the bootstrap
mode. Only the OS changes what is applied, plus the WSL check inside `gaftenv`,
which on Linux under WSL hands a missing command to its `.exe` counterpart.

## Managed targets

| Target | Type | Platforms |
| --- | --- | --- |
| `~/.aliases-functions` | file | all |
| `~/.bash_profile` | file | macOS, Windows |
| `~/.bashrc` | file | macOS, Windows |
| `~/.config/atuin/config.toml` | tracked keys | all |
| `~/.config/atuin/themes` | external | all |
| `~/.config/bat/config` | file | all |
| `~/.config/bat/themes` | external | all |
| `~/.config/delta` | external | all |
| `~/.config/fzf/config` | file | all |
| `~/.config/lazygit/config.yml` | file | all |
| `~/.config/mise/config.toml` | tracked keys | macOS, Linux |
| `~/.config/starship.toml` | file | all |
| `~/.config/wezterm/keymaps.lua` | file | macOS, Windows |
| `~/.config/wezterm/wezterm.lua` | file | macOS, Windows |
| `~/.config/yazi/Catppuccin-macchiato.tmTheme` | external | all |
| `~/.config/yazi/theme.toml` | external | all |
| `~/.config/yazi/yazi.toml` | file | all |
| `~/.gitconfig` | file | all |
| `~/.profile` | file | macOS, Windows |
| `~/.profile.d` | directory | macOS, Windows |
| `~/.profile.d/0_start-ssh-agent.sh` | file | Windows |
| `~/.ssh` | directory | all |
| `~/.vim/after/plugin` | external | all |
| `~/.vim/pack/plugins/start` | external | all |
| `~/.vim/pack/themes/start` | external | all |
| `~/.vim/plugin/keymaps.vim` | file | all |
| `~/.vimrc` | file | all |
| `~/.zprofile` | file | macOS |
| `~/.zsh` | external | macOS |
| `~/.zshrc` | file | macOS |
| `~/Sites` | directory | macOS, Windows |
| `~/gaftenv` | file | all |
| `~/projects` | directory | macOS, Windows |

The install scripts are not targets; they have their own section below.

`home/.chezmoiignore` sets the Platforms column. zsh is the login shell on macOS
only, so the zsh startup files stay there; Windows logs in through Git Bash, which
reads the bash and profile startup files. macOS leaves out the ssh-agent startup
script because launchd already gives each login an agent. Windows leaves out mise's
config, since mise is not installed there. Linux is treated as a remote machine: it
leaves out the bash and profile startup files in favor of `gaftenv`, sourced per
session, and the wezterm config and the `projects` and `Sites` directories, which
serve a machine someone works at.

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

## Externals

`home/.chezmoiexternal.yaml.tmpl` downloads, on apply, the Catppuccin themes for
atuin, bat, delta, yazi and vim, the vim plugin file fzf ships, five vim plugins,
and on macOS only the three zsh plugins that `~/.zshrc` sources. Every URL follows a
branch head, but none sets `refreshPeriod`, so chezmoi downloads each once and
serves it from its cache after that. An external refreshes only when its URL changes
or an apply passes `--refresh-externals` (`-R`).

The vim theme and plugins are `exact` archives under `~/.vim/pack`: each apply
removes any file added by hand inside them. The zsh archive is not `exact`, so files
beside the plugins in `~/.zsh` survive.

## Listed packages

`home/.chezmoidata.yaml` declares the **listed packages** under `packages` in four
lists: the **common list**, the **local list**, and one list each for macOS
(`darwin`) and Windows (`windows`). Which lists reach a machine, and through which
package manager, depends on the OS:

| OS | Lists | Installed by |
| --- | --- | --- |
| macOS | common, local, `darwin` | Homebrew |
| Windows | common, local, `windows` | scoop |
| Linux | common | apt for git, mise for the rest |

macOS and Windows install all three of their lists, whichever bootstrap set the
machine up. Linux installs only the common list: setup-machine installs git with
apt, and install-packages runs `mise install`, which reads the `tools` tracked keys
that mise's `modify_` template derives from the common list. apt installs no other
listed package. The OS stands in for the bootstrap mode, so Linux is treated as
remote: a Linux machine set up by a local bootstrap, as under WSL, gets no local
list either.

Windows skips one local-list package, `dtop`, by name in its install script: neither
scoop's main bucket nor the extras bucket setup-machine adds carries a manifest for
it.

## Install scripts

Each OS has three scripts under `home/.chezmoiscripts/<os>/`, and
`home/.chezmoiignore` leaves out the other OSes' directories.

| Script | Runs | Does | A failure |
| --- | --- | --- | --- |
| setup-machine | `run_once_before_`: before any target, on the first apply and again only when the script changes | Installs what the rest of the apply needs: Homebrew on macOS, scoop on Windows, curl, ca-certificates, git and file with apt on Linux, then atuin and pnpm everywhere and mise on macOS and Linux. Windows also installs git with scoop if missing and adds the extras and nerd-fonts buckets. A tool already present is self-updated instead, except git and atuin on Windows. | A failed install fails the apply; a failed self-update does not. |
| install-packages | `run_onchange_`: on the first apply and again only when the rendered script changes; `after_` on Linux only | Installs the listed packages for the OS, as in Listed packages. | Fails the apply. |
| setup-environment | `run_once_after_`: after all targets, on the first apply and again only when the script changes | Installs the latest Node.js runtime and npm globally through pnpm. macOS and Linux then set npm's global prefix to `~/.local`; Windows first sets the user environment variables its tools read and builds bat's cache. | A failed pnpm step fails the apply. |

- `run_once_` means the self-update branches in setup-machine fire again only when
  the script changes: an apply on an established machine updates none of those
  tools. A `run_once_` script that failed runs again on the next apply.
- `run_onchange_` reruns only when the rendered package list changes, so apply never
  upgrades a package, and dropping a package from a list does not uninstall it.
  Linux's install script carries the common list in a comment only to trigger that
  rerun; `mise install` reads mise's config, not the script.
- Linux's install-packages is an `after_` script, so it runs once every target is
  written, mise's config included. macOS's and Windows' carry neither `before_` nor
  `after_`, so they run among the targets in ASCII order of their target names under
  `.chezmoiscripts/`: after `~/.aliases-functions`, `~/.bash_profile` and
  `~/.bashrc`, and before `~/.config` and every target after it.
- macOS and Linux ignore a failed self-update with `|| true`. Windows has no
  `|| true`, but it checks neither `scoop update` nor `pnpm self-update` either:
  unlike the git and atuin installs, which throw on a non-zero exit code, a failed
  update leaves the script running, and pwsh reports success for a script that ends
  without a terminating error. Since the script then succeeds, `run_once_` does not
  retry the update.

The Windows scripts carry the awkward parts, each explained in a comment where it
sits: environment and PATH entries their installers set only in the registry, and
a `tar` collision inherited from Git Bash.
