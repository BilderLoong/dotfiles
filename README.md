
# Directory Structure
  `./termux`: contain all config files used for termux 'on' my "nex" .



## Install Package

```bash
git checkout HEAD
stow */ -t ~ --adopt
git checkout HEAD
stow --restow */ -t ~
```


For Rime on the macOS:

```shell
stow -S Rime -t ~/Library/Rime
```

## Reference
https://unix.stackexchange.com/questions/705401/delete-all-target-links-and-files-before-running-gnu-stow
