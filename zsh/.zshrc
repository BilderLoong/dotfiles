# If the system run in Windows
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
	# Should be placed at the beginning of the init, so that the below commands that need to send network be proxied.
	# Proxy the WSL
	## 获取主机 IP
	## 主机 IP 保存在 /etc/resolv.conf 中
	export hostip=$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*') 
	export proxy_address="http://${hostip}:7890" 
	# export all_proxy=$proxy_address
	# export http_proxy=$proxy_address
	# export https_proxy=$proxy_address
	export D="/mnt/d"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Plugins

# Antigen plugins 
# Init Antigen
# If antigen.zsh don't exist, install it.
if [[ ! -e ~/antigen.zsh ]]; then
	curl -L git.io/antigen > ~/antigen.zsh
fi
source ~/antigen.zsh
# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Antigen Plugins List

# Use fnm intead of zsh-nvm.
# Reason to use nvm instead of nvm directly: https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load/
# export NVM_AUTO_USE=true
# antigen bundle lukechilds/zsh-nvm 

# Load bundles from the default repo (oh-my-zsh)
antigen bundle command-not-found

# Load bundles from external repos
antigen bundle jeffreytse/zsh-vi-mode
ZVM_VI_ESCAPE_BINDKEY=jk # The vi escape key in all modes (default is ^[ => ESC)

antigen bundle zsh-users/zsh-syntax-highlighting

# Fish-like fast/unobtrusive autosuggestions for zsh.
antigen bundle zsh-users/zsh-autosuggestions # end key or right arrow key accept suggestion.

# Additional completion definitions for Zsh.
antigen bundle zsh-users/zsh-completions

# Tell Antigen that you're done.
antigen apply

# Oh-My-Zsh plugins custom plugins
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias zshconfig="source ~/.zshrc"
alias configpush="cd ~/dotfiles; stow -R *; git add .; git commit -m 'config push'; git pull origin HEAD; git push origin HEAD; cd - "
alias nvimconfig="nvim ~/.config/nvim/init.vim"
alias v="nvim"

alias gsave='git add .; git commit -m "save"; git push origin HEAD'

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
export https_proxy=http://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export all_proxy=socks5://127.0.0.1:7890
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PNPM_HOME="/home/bilder/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Fnm setup:https://github.com/Schniz/fnm#shell-setup
eval "$(fnm env --use-on-cd)"

# Pyenv setup
# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

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
