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


# If the system is running on WSL.
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
	source "$ZSH_CUSTOM/wsl.sh"
fi

# If the system is running on termux.
if [ $(ps -ef | grep -c com.termux) -gt 0 ]; then
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

PATH="/Users/birudo/perl5/bin${PATH:+:${PATH}}"
export PATH
PERL5LIB="/Users/birudo/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL5LIB
PERL_LOCAL_LIB_ROOT="/Users/birudo/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_LOCAL_LIB_ROOT
PERL_MB_OPT="--install_base \"/Users/birudo/perl5\""
export PERL_MB_OPT
PERL_MM_OPT="INSTALL_BASE=/Users/birudo/perl5"
export PERL_MM_OPT


# Android
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin/


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# snap
export PATH="/snap/bin:$PATH"

# GO
export PATH="$HOME/go/bin:$PATH"

# zprof
