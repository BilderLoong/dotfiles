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
[ -s "/home/birudo/.bun/_bun" ] && source "/home/birudo/.bunajjj/_bun"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


