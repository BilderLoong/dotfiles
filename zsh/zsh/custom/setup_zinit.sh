# Docs:
# https://github.com/zdharma-continuum/zinit
# https://github.com/NICHOLAS85/z-a-eval

# === Zinit Config — Layer System ===
# See ~/zsh/custom/SETUP_ZINIT.md for background knowledge and how to add new plugins.
#
#   L1 wait"0a" — Infrastructure: generates _* completions, sets shared env vars
#   L2 wait"0b" — Plugins: everything else (default)
#
# Plugin types: A=completion stdout, B=completion side-effect, C=completion file,
#               D=binary+completion, E=shell plugin, F=env init, G=OMZ lib/snippet

# Plugins
# export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
### Added by Zinit's installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ── Synchronous ──────────────────────────────────────────────────────────────
# Annexes MUST load synchronously before any eval ice is used.

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit light-mode for \
    NICHOLAS85/z-a-eval

### End of Zinit's installer chunk

# ── L1 Infrastructure (wait"0a") ─────────────────────────────────────────────
# Generates _* completion files and sets env vars other layers consume.
# Add here: Type A, B, C completions. Type F env inits that set PATH.

# Type E — L1 so keybindings are ready early.
zinit wait"0a" lucid atinit"ZVM_VI_ESCAPE_BINDKEY=jk;  ZVM_INIT_MODE=sourcing" for \
    jeffreytse/zsh-vi-mode

# Types A, B, C, F — completions + environment setup.
zinit wait"0a" lucid for \
    has'syncthing' id-as'syncthing-completions' \
        eval"syncthing install-completions" \
        zdharma-continuum/null \
    has'ast-grep' id-as'sg-completions' as'completion' nocompile \
        atclone'ast-grep completions zsh > _ast-grep' \
        atpull'%atclone' run-atpull \
        zdharma-continuum/null \
    has'poetry' id-as'poetry_completions' as'completion' nocompile \
        atclone'poetry completions zsh > _poetry' \
        atpull'%atclone' run-atpull \
        zdharma-continuum/null \
    has'opencode' id-as'opencode-completions' as'completion' nocompile \
        atclone'opencode completion > _opencode' \
        atpull'%atclone' run-atpull \
        zdharma-continuum/null \
    has'uv' id-as'uv-completions' as'completion' nocompile \
        atclone'uv generate-shell-completion zsh > _uv' \
        atpull'%atclone' run-atpull \
        zdharma-continuum/null \
    has'uv' id-as'uvx-completions' as'completion' nocompile \
        atclone'uvx --generate-shell-completion zsh > _uvx' \
        atpull'%atclone' run-atpull \
        zdharma-continuum/null \
    has'claude' id-as'claude-completions' as'completion' \
        wbingli/zsh-claudecode-completion \
    has"pyenv" id-as"pyenv_init" \
        atinit'export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"' \
        eval"pyenv init -" \
        zdharma-continuum/null \
    id-as"async_source" \
        atinit"source $ZSH_CUSTOM/lazy/main.zsh" \
        zdharma-continuum/null

# ── L2 Plugins (wait"0b") ────────────────────────────────────────────────────
# Independent — don't generate completions, don't consume completion state at startup.
# This is the DEFAULT layer. Add here: Type D, E, F, G.

# Types G, E, F — OMZ libs, shell plugins, env inits.
zinit wait"0b" lucid for \
    has'git' OMZL::git.zsh \
    has'git' OMZP::git \
    Aloxaf/fzf-tab \
    has'eza' mdarrint/zsh-aliases-exa \
    zdharma-continuum/fast-syntax-highlighting \
    has'zoxide' eval"zoxide init zsh"  ajeetdsouza/zoxide \
    id-as'fnm_env' as"null" has"fnm" eval"fnm env --use-on-cd" \
        zdharma-continuum/null \
    id-as"thefuck_init" as"null" has"thefuck" eval"thefuck --alias" \
        zdharma-continuum/null \
    id-as'navi-widget' as"null" has'navi' eval"navi widget zsh" \
        zdharma-continuum/null

# Type D — binary + completion generation from GitHub releases.
zinit wait"0b" lucid as"command" from"gh-r" \
    bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" \
    atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" \
    atpull"%atclone" src"init.zsh" \
    for atuinsh/atuin

# Type F — wait'!0' overrides block-level wait"0b".
# The ! forces immediate zle reset-prompt so starship renders on first display.
zinit wait"0b" lucid for \
    id-as'starship_init' as"null" wait'!0' has'starship' \
        eval"starship init zsh" \
        zdharma-continuum/null

# Type E — autosuggestions. Binds zle widgets only; queries completions lazily at
# type time, so ordering relative to completion plugins doesn't matter.
zinit wait"0b" lucid atload'_zsh_autosuggest_start' for \
    zsh-users/zsh-autosuggestions

# ── Finalize: zicompinit + zicdreplay ─────────────────────────────────────────
# zicompinit: runs compinit to discover _* files in $fpath
# zicdreplay: replays compdef calls captured during plugin loading
# Must be the LAST item in L2 — declaration order ensures it runs after every
# other plugin, so all compdef calls are already captured when zicdreplay fires.
zinit wait"0b" lucid as"null" atload'zicompinit; zicdreplay' for \
    zdharma-continuum/null
