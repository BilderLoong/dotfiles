export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

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


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# snap
export PATH="/snap/bin:$PATH"

# GO
export PATH="$HOME/go/bin:$PATH"
source "$ZSH_CUSTOM/lazy/zle.sh"

source "$ZSH_CUSTOM/functionsAndAlias.sh"

# If the system is running on WSL.
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
	source "$ZSH_CUSTOM/wsl.sh"
fi

# https://stackoverflow.com/a/54618022/11602758
if [[ $(uname) == "Darwin" ]]; then
	source "$ZSH_CUSTOM/macOS.sh"
fi

export SDKMAN_DIR="$HOME/.sdkman"
# Have side effect of calling `compinit`.
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Cargo
. "$HOME/.cargo/env"

[[ -s "$HOME/.luaver/luaver" ]] && source "$HOME/.luaver/luaver" 

# zprof

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/birudo/.sdkman"
[[ -s "/home/birudo/.sdkman/bin/sdkman-init.sh" ]] && source "/home/birudo/.sdkman/bin/sdkman-init.sh"


[[ -f ~/.zsh_secrets ]] && source ~/.zsh_secrets

# pnpm
export PNPM_HOME="/Users/birudo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# Added by Antigravity
export PATH="/Users/birudo/.antigravity/antigravity/bin:$PATH"

# opencode
export PATH=/Users/birudo/.opencode/bin:$PATH


[[ -z]]