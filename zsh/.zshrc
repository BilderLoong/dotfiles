# Who called compinit?
# autoload -Uz compinit
# functions[_real_compinit]=$functions[compinit]

# typeset -gi __compinit_call_count=0

# compinit() {
#   ((__compinit_call_count++))

#   print -P "\n%F{yellow}========== COMPINIT #$__compinit_call_count ==========%f"

#   print -P "%F{cyan}ARGS:%f $*"

#   print -P "%F{cyan}STACK:%f"
#   printf '  %s\n' "${funcfiletrace[@]}"

#   print -P "%F{yellow}=======================================%f\n"

#   _real_compinit "$@"
# }

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

source "$ZSH_CUSTOM/setup_zinit.sh"

# If the system is running on termux.
if [ $(ps -ef | grep -c com.termux) -gt 0 ]; then
	source "$ZSH_CUSTOM/termux.sh"
fi

# zprof
