# zmodload zsh/zprof

ZSH_CUSTOM="$HOME/zsh/custom"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#user-config
export XDG_CONFIG_HOME="$HOME/.config"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=9999
SAVEHIST=9999
setopt appendhistory


HYPHEN_INSENSITIVE="true"

export EDITOR='nvim'

source "$ZSH_CUSTOM/zinit.sh"
source "$ZSH_CUSTOM/functionsAndAlias.sh"

# https://stackoverflow.com/a/54618022/11602758
if [[ $(uname) == "Darwin" ]]; then
    source "$ZSH_CUSTOM/macOS.sh"
fi

# If the system is running on WSL.
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
  source "$ZSH_CUSTOM/wsl.sh"
fi

# If the system is running on termux.
if [ $(ps -ef|grep -c com.termux ) -gt 0 ]; then
 source "$ZSH_CUSTOM/termux.sh"
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PNPM_HOME="/home/bilder/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# pnpm
export PNPM_HOME="/Users/birudo/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm endexport PATH="/usr/local/sbin:$PATH"
# Adding from the brew doctor warning 
export PATH="/usr/local/sbin:$PATH"

PATH="/Users/birudo/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/birudo/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/birudo/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/birudo/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/birudo/perl5"; export PERL_MM_OPT;

#JAVA
# export JAVA_HOME=$(/usr/libexec/java_home)

# Android
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin/

# Go
export PATH=$PATH:$GOPATH/bin

# source "$HOME/Project/zsh-autocomplete/zsh-autocomplete.plugin.zsh"


# zprof

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f "/home/birudo/.ghcup/env" ] && source "/home/birudo/.ghcup/env" # ghcup-env

# bun completions
[ -s "/home/birudo/.bun/_bun" ] && source "/home/birudo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# snpa
export PATH="/snap/bin:$PATH"
export PATH=/home/birudo/go/bin:/home/birudo/.pyenv/shims:/home/birudo/.pyenv/bin:/mnt/wslg/runtime-dir/fnm_multishells/31649_1693720052493/bin:/snap/bin:/home/birudo/.bun/bin:/Users/birudo/perl5/bin:/usr/local/sbin:/Users/birudo/Library/pnpm:/home/bilder/.local/share/pnpm:/home/birudo/.yarn/bin:/home/birudo/.config/yarn/global/node_modules/.bin:/mnt/wslg/runtime-dir/fnm_multishells/31649_1693720052493/bin:/home/birudo/.local/bin:/home/birudo/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/home/birudo/.pyenv/bin:/home/birudo/.local/share/zinit/plugins/ajeetdsouza---zoxide:/mnt/wslg/runtime-dir/fnm_multishells/31649_1693720052493/bin:/home/birudo/.bun/bin:/home/birudo/.cabal/bin:/home/birudo/.ghcup/bin:/Users/birudo/perl5/bin:/usr/local/sbin:/Users/birudo/Library/pnpm:/home/bilder/.local/share/pnpm:/home/birudo/.yarn/bin:/home/birudo/.config/yarn/global/node_modules/.bin:/mnt/wslg/runtime-dir/fnm_multishells/31649_1693720052493/bin:/home/birudo/.local/share/zinit/polaris/bin:/home/birudo/.local/bin:/home/birudo/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Python311/Scripts/:/mnt/c/Python311/:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/ProgramData/chocolatey/bin:/mnt/c/Program Files/Git/cmd:/mnt/c/ProgramData/chocolatey/lib/mpv.install/tools:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/Microsoft VS Code/bin:/mnt/c/Program Files/Bandizip/:/mnt/c/Program Files/Calibre2/:/mnt/c/Program Files/usbipd-win/:/mnt/c/Program Files (x86)/oh-my-posh/bin:/mnt/c/Program Files/dotnet/:/mnt/c/Users/birudo/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/birudo/AppData/Roaming/npm:/tools:/platform-tools:/cmdline-tools/latest/bin/:/bin:/tools:/platform-tools:/cmdline-tools/latest/bin/:/bin
