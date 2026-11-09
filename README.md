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

## Docs

- [Architecture](docs/ARCHITECTURE.md): what the repo manages and how each
  part is owned.
- [Development](docs/DEVELOPMENT.md): authoring the source state and
  validating it.
- [Glossary](docs/GLOSSARY.md): the vocabulary used throughout.
