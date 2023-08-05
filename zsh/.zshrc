# zmodload zsh/zprof

ZSH_CUSTOM="$HOME/zsh/custom"

source "$ZSH_CUSTOM/zinit.sh"

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

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#user-config
export XDG_CONFIG_HOME="$HOME/.config"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=9999
setopt appendhistory


 HYPHEN_INSENSITIVE="true"

export EDITOR='nvim'


# Shortcut
alias sync-config="cd $HOME/Projects/dotfiles &&  git-auto-sync w . &"
alias v="nvim"
alias lv="lvim"
alias gwl="git worktree list"
alias cd='z'

unproxy() {
  unset proxy_address
  unset all_proxy
  unset http_proxy
  unset https_proxy
}
# Git

# Function to clone a specific repository
# Arguments:
#   $1: Repository name
#   $2: Destination path
# Example usage:
# clone_my_repo my-repo /path/to/destination
clone_my_repo() {
  # Check if the required arguments are provided
  if [ -z "$1" ]; then
    echo "Please provide repo name"
    return 1
  fi

  repo_name=$1
  dist_path=$2

  git clone git@github.com:BilderLoong/${repo_name}.git "$dist_path"
}

proxy (){
  port=$1

	export proxy_address="http://127.0.0.1:${port:-7890}" 
	export all_proxy=$proxy_address
	export http_proxy=$proxy_address
	export https_proxy=$proxy_address
}



alias gsave='git add . && git commit -m "save" && git pull origin HEAD &&  git push origin HEAD'

# The wechat mp devtool cli path: https://segmentfault.com/a/1190000040867117 .
wechatcli () {
  wechatcli='/Applications/wechatwebdevtools.app/Contents/MacOS/cli'

  if [[ -z "$1" ]] 
  then
    "${wechatcli}"
  else
   ${wechatcli} open --project ~/Project/menuorder-new-rms-h5-$1/apps/menuorder/dist/merchant
  fi
}

# rm_all_nest_node_modules
trash_all_nest_node_modules () {
  directory=${1:-.}
  echo "removing ${directory}"
  find $1 -name 'node_modules' -type d -prune -exec trash -rf '{}' +
}

# Personal Used Variables
if [[ $OSTYPE == 'darwin'* ]]; then
    # Make Ankiconnect be able to run in background, source: https://github.com/FooSoft/anki-connect#installation
  defaults write net.ankiweb.dtop NSAppSleepDisabled -bool true
  defaults write net.ichi2.anki NSAppSleepDisabled -bool true
  defaults write org.qt-project.Qt.QtWebEngineCore NSAppSleepDisabled -bool true

  # Change the homebrew packages source.
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles

  # Use Clash proxy.
  # export https_proxy=http://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export all_proxy=socks5://127.0.0.1:7890
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

alias emulator="cd $ANDROID_HOME/tools && emulator"


# zprof
