#!/bin/zsh

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
        has"fnm" eval"fnm env --use-on-cd" id-as'fnm_env' \
      zdharma-continuum/null  




# Meaing of `lucid`: https://zdharma-continuum.github.io/zinit/wiki/Example-Minimal-Setup/
zinit wait lucid for \
    OMZP::command-not-found \
    has'git' OMZL::git.zsh \
    has'git' OMZP::git \
    has'exa' DarrinTisdale/zsh-aliases-exa \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-completions 
    #   atclone"shell/key-bindings.zsh" \
    #   atpull"%atclone" \
    #   multisrc"shell/{completion,key-bindings}.zsh" \
    #   id-as"junegunn/fzf_completions" \
    # pick"/dev/null" junegunn/fzf 


# Fish-like autosuggestions for zsh 
zinit wait lucid atload'_zsh_autosuggest_start' for \
      zsh-users/zsh-autosuggestions 

# Put this after other plugins may also bind "^I"
# https://github.com/Aloxaf/fzf-tab#compatibility-with-other-plugins
# https://github.com/Aloxaf/fzf-tab#install
# Got error for this plugin, given up
# zinit light Aloxaf/fzf-tab

zinit wait lucid for \
  has'starship' id-as'starship_init' eval"starship init zsh" \
  zdharma-continuum/null  
zinit ice wait lucid as"command" from"gh-r" mv"zoxide* -> zoxide" \
      eval"zoxide init zsh"
zinit light ajeetdsouza/zoxide


# Use `id-as` to avoid conflic.
zinit wait"1" lucid for \
    has"pyenv" eval"pyenv init -" atinit'export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"' \
  zdharma-continuum/null 



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
