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
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space # Put a space to omit this command from history.

HYPHEN_INSENSITIVE="true"

export EDITOR='nvim'

source "$ZSH_CUSTOM/zinit.sh"

# If the system is running on termux.
if [ $(ps -ef | grep -c com.termux) -gt 0 ]; then
	source "$ZSH_CUSTOM/termux.sh"
fi

# [[ -s "$HOME/.luaver/luaver" ]] && source "$HOME/.luaver/luaver" 

# zprof
