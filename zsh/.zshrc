# zmodload zsh/zprof

ZSH_CUSTOM=~/zsh/custom

# https://stackoverflow.com/a/54618022/11602758
if [[ $(uname) == "Darwin" ]]; then
    source "$ZSH_CUSTOM/macOS.sh"
fi



# If the system run in Windows
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
	# Should be placed at the beginning of the init, so that the below commands that need to send network be proxied.
	# Proxy the WSL
	## 获取主机 IP
	## 主机 IP 保存在 /etc/resolv.conf 中
	# export hostip=$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*') 
	# export proxy_address="http://${hostip}:7890" 
	# export all_proxy=$proxy_address
	# export http_proxy=$proxy_address
	# export https_proxy=$proxy_address
	export D="/mnt/d"
  # For Android Studio
  export GDK_SCALE=3
  export GDK_DPI_SCALE=0.5
  alias android-studio="/opt/android-studio/bin/studio.sh > /dev/null 2>&1"

fi

if [ $(ps -ef|grep -c com.termux ) -gt 0 ]; then
	export LOGSEQ='/data/data/com.termux/files/home/storage/shared/Download/Sync/MaxLumi/Logseq'
    alias xc='termux-clipboard-set'
    alias xp='termux-clipboard-get'

    open () 
    { 
        termux-share "$@"
    }
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

# Plugins

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# zinit user plugins.
# The vi escape key in all modes (default is ^[ => ESC)
zinit light-mode for \
      atinit"ZVM_VI_ESCAPE_BINDKEY=jk" \
      jeffreytse/zsh-vi-mode \
      NICHOLAS85/z-a-eval \
      Aloxaf/fzf-tab
      Aloxaf/fzf-tab

# Meaing of `lucid`: https://zdharma-continuum.github.io/zinit/wiki/Example-Minimal-Setup/
zinit wait lucid for \
    OMZP::command-not-found \
    has'git' OMZL::git.zsh \
    has'git' OMZP::git \
    has'exa' DarrinTisdale/zsh-aliases-exa \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-completions 

# zinit light @marlonrichert/zsh-autocomplete 


# Fish-like autosuggestions for zsh 
zinit wait lucid atload'_zsh_autosuggest_start' for \
      zsh-users/zsh-autosuggestions 


# https://github.com/NICHOLAS85/z-a-eval#ice-modifiers-provided-by-the-annex
# zinit ice lucid as"command" from"gh-r" mv"zoxide* -> zoxide" \
#       eval'zoxide init zsh' \
# zinit light ajeetdsouza/zoxide

zinit lucid for \
  has'starship' id-as'starship_init' eval"starship init zsh" \
  zdharma-continuum/null  

zinit ice as"command" from"gh-r" mv"zoxide* -> zoxide" \
      eval"zoxide init zsh"
zinit light ajeetdsouza/zoxide
# zinit lucid for \
#     has'zoxide' id-as'zoxide_init' eval'zoxide init zsh' \
#   zdharma-continuum/null


# Use `id-as` to avoid conflic.
zinit wait"1" lucid for \
    has"fnm" eval"fnm env --use-on-cd" id-as'fnm_env'\
  zdharma-continuum/null \
    has"pyenv" eval"pyenv init -" atinit'export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"' \
  zdharma-continuum/null 
  # id-as'fnm_env' \
  # zdharma-continuum/null

# zinit as'null' lucid sbin wait'1' for \
#   Fakerr/git-recall \
#   davidosomething/git-my \
#   iwata/git-now \
#   paulirish/git-open \
#   paulirish/git-recent \
#     atload'export _MENU_THEME=legacy' \
#   arzzen/git-quick-stats \
#     make'install' \
#   tj/git-extras \
#     make'GITURL_NO_CGITURL=1' \
#     sbin'git-url;git-guclone' \
#   zdharma-continuum/git-url
#
# ==== zinit plugins end ====


export EDITOR='nvim'


# Shortcut
alias zshconfig="source ~/.zshrc"
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

# Make it easy to asscess dotfiles
# Note that to use tidle expansion, 
df=~/Project/dotfiles

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

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

#JAVA
# export JAVA_HOME=$(/usr/libexec/java_home)

# Android
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin/

alias emulator="cd $ANDROID_HOME/tools && emulator"


# zprof
