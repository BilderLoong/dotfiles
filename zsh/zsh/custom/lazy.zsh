source "$ZSH_CUSTOM/functionsAndAlias.sh"
# https://stackoverflow.com/a/54618022/11602758
if [[ $(uname) == "Darwin" ]]; then
	source "$ZSH_CUSTOM/macOS.sh"
fi

# bun completions
[ -s "/home/birudo/.bun/_bun" ] && source "/home/birudo/.bunajjj/_bun"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


