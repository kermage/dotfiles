# dotfiles

Shell, editor, and command-line tool configuration, applied to each machine by
chezmoi on its default paths.

## Language

### Bootstrapping

**Local bootstrap**:
Setting up a machine that keeps its source checkout and config, so later applies
pick up changes to the repo. A Linux machine may be local, as under WSL.
_Avoid_: full install, desktop install

**Remote bootstrap**:
Setting up a machine in one shot: apply once, then keep no source checkout or
config behind.
_Avoid_: server install, Linux install

### Packages

**Listed package**:
A package the repo declares by name, installed on apply by the machine's package
manager.
_Avoid_: managed package, tool

**Common list**:
The listed packages every machine gets, whichever bootstrap set it up.
_Avoid_: base packages, core packages

**Local list**:
The listed packages meant only for a machine set up by a local bootstrap, on top of
the common list.
_Avoid_: desktop packages, extra packages, dev packages

### Settings files

**Tracked key**:
A key in a settings file whose value the repo owns and enforces on apply, in a file
that also holds keys the repo does not own. It may be a nested path inside a table;
its whole value, including any array or table under it, belongs to the repo.
_Avoid_: managed key, synced setting

**Machine-owned key**:
A key in the same settings file that the program, another app, or the local user
owns, which apply preserves untouched.
_Avoid_: local key, local line, untracked key, ignored key
