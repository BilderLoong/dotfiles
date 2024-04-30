export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PNPM_HOME="/home/bilder/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"


# pnpm
export PNPM_HOME="/Users/birudo/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

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

# bun completions
[ -s "/home/birudo/.bun/_bun" ] && source "/home/birudo/.bun/_bun"
[ -s "/Users/birudo/.bun/_bun" ] && source "/Users/birudo/.bun/_bun"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Cargo
. "$HOME/.cargo/env"

export GITHUB_API_URL=http://124.220.157.23:8800
export GITHUB_SERVER_URL=https://github.com
export GITHUB_TOKEN=ODM1Ljk0YWRjM2ZhMDljZmFlOWM4MTYwOWY1NWQ2OWM4OWE2
