# Docs: https://github.com/zdharma-continuum/zinit
# https://github.com/NICHOLAS85/z-a-eval


# Plugins
export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
### Added by Zinit's installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

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

# Meaning of `lucid`: https://zdharma-continuum.github.io/zinit/wiki/Example-Minimal-Setup/
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
        has'ast-grep' id-as'sg-completions' as'completion' \
            atclone'ast-grep completions zsh > _ast-grep' atpull'%atclone' nocompile \
    zdharma-continuum/null \
        has'syncthing' id-as'syncthing-completions' eval"syncthing install-completions" \
    zdharma-continuum/null \
        has'opencode' id-as'opencode-completions' as'completion' nocompile \
            atclone'opencode completion > _opencode' atpull'%atinit' \
    zdharma-continuum/null 

# Fish-like autosuggestions for zsh 
zinit wait lucid atload'_zsh_autosuggest_start' for \
      zsh-users/zsh-autosuggestions 

# Without *atload* the <Tap> completions of path doesn't work.
zinit ice wait lucid atload'zicompinit; zicdreplay' as"command" from"gh-r"  eval"zoxide init zsh"
zinit light ajeetdsouza/zoxide

# zinit ice id-as"opencode-completion" has"opencode" \
#     atclone"opencode completion zsh > _opencode; zinit creinstall -q opencode-completion" \
#     atpull"%atclone" 
# zinit light zdharma-continuum/null

# Use `id-as` to avoid conflict.
zinit wait"1" lucid for \
    has"pyenv" eval"pyenv init -" \
    id-as"pyenv_init" \
    atinit'export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"' \
  zdharma-continuum/null \
    id-as"async_source" \
    atinit"source $ZSH_CUSTOM/lazy/main.zsh" \
  zdharma-continuum/null 


# line 1: `atuin` binary as command, from github release, only look at .tar.gz files, use the `atuin` file from the extracted archive
# line 2: setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice wait lucid as"command" from"gh-r" bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" \
    atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" \
    atpull"%atclone" src"init.zsh"
zinit light atuinsh/atuin

# https://www.reddit.com/r/zinit/comments/j1al1v/add_completion_from_github_page_zinit/
# zinit ice wait lucid  as"completion" from"gh-r" id-as"dbrgn/_tealdeer" bpick"completions_zsh" \
#     mv"completions_zsh -> _tldr" \
#     pick"_tldr" \
#     atpull'!git reset --hard' 
# zinit light dbrgn/tealdeer

