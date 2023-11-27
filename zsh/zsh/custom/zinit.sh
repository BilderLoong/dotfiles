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

# `zicompinit` replace the below commands.
# autoload -Uz compinit
# compinit

# Meaing of `lucid`: https://zdharma-continuum.github.io/zinit/wiki/Example-Minimal-Setup/
zinit wait lucid atload'zicompinit; zicdreplay' for \
    OMZP::command-not-found \
    has'git' OMZL::git.zsh \
    has'git' OMZP::git \
    has'exa' DarrinTisdale/zsh-aliases-exa \
    zdharma-continuum/fast-syntax-highlighting \
        has"fnm" id-as'fnm_env' eval"fnm env --use-on-cd" \
    zdharma-continuum/null  \
         wait'!0' has'starship' id-as'starship_init' eval"starship init zsh" \
    zdharma-continuum/null  \
      has"thefuck" id-as"thefuck_init" eval"thefuck --alias" \
    zdharma-continuum/null \
    Aloxaf/fzf-tab \
         has'navi' id-as'navi-widget' eval"navi widget zsh" \
    zdharma-continuum/null \
        has'ast-grep' id-as'sg-completions' eval"ast-grep completions" \
    zdharma-continuum/null

# Fish-like autosuggestions for zsh 
zinit wait lucid atload'_zsh_autosuggest_start' for \
      zsh-users/zsh-autosuggestions 

zinit ice wait lucid as"command" from"gh-r"  eval"zoxide init zsh"
zinit light ajeetdsouza/zoxide


# Use `id-as` to avoid conflic.
zinit wait"1" lucid for \
    has"pyenv" eval"pyenv init -" \
    id-as"pyenv_init" \
    atinit'export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"' \
  zdharma-continuum/null \
    
    id-as"skdman" \
    atinit"source $HOME/.sdkman/bin/sdkman-init.sh" \
  zdharma-continuum/null 


# https://www.reddit.com/r/zinit/comments/j1al1v/add_completion_from_github_page_zinit/
zinit ice wait lucid  as"completion" from"gh-r" id-as"dbrgn/_tealdeer" bpick"completions_zsh" \
    mv"completions_zsh -> _tldr" \
    pick"_tldr" \
    atpull'!git reset --hard' 
zinit light dbrgn/tealdeer

