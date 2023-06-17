
## Directory Structure
`./termux`: contain all config files used for termux on my nex phone.


## Install Package

```bash
git checkout HEAD
stow */ -t ~ --adopt
git checkout HEAD
stow --restow */ -t ~
```

## Reference
https://unix.stackexchange.com/questions/705401/delete-all-target-links-and-files-before-running-gnu-stow
