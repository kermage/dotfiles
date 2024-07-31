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
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/bin init kermage
```

### Remote

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init kermage --one-shot
```

#### Setup session

```bash
source gaftenv
```
