# tmux Underline Color Fix Plan

**Goal:** Preserve Neovim's diagnostic underline color in Alacritty through tmux.

## Evidence
- tmux 3.5a, active client terminal name alacritty.
- Smulx is present; Setulc and Setulc1 are missing.
- tmux manual defines usstyle as allowing underscore style and colour.
- ~/.tmux.conf resolves to /Users/birudo/Projects/dotfiles/tmux/.tmux.conf.

## Proposed change
Add near the top of that file:
```tmux
# Preserve underline styles and colors in Alacritty.
set -as terminal-features ',alacritty:usstyle'
```
Scope only Alacritty. Preserve existing feature entries. Do not change TERM, theme, fonts, RGB support, or Neovim highlights.

## Steps after approval
1. Establish a visual baseline outside and inside tmux in Alacritty. Use identical escape sequences, white text plus red curly underline:
```sh
printf '\033[0m\033[37m\033[4:3m\033[58:2::255:0:0mUnderline test\033[0m\n'
```
If direct Alacritty does not show red, stop and investigate terminal support rather than assume tmux alone.
2. Test the feature in an isolated tmux server with minimal configuration, avoiding existing plugins and sessions. Compare the same sample and inspect tmux info for Setulc.
3. If the isolated test passes, add the single feature entry to the canonical dotfile. Apply only that option to the live server to avoid re-running unrelated plugin initialization.
4. Detach and reattach the Alacritty client if capabilities do not update immediately. Keep all sessions and running Neovim processes. Never kill the tmux server.
5. Verify client features include usstyle and tmux info exposes Setulc. Repeat the color sample and inspect the original diagnostic. Save work before restarting Neovim only if cached capability detection requires it.
6. Repeat the visual check and verify other clients are unaffected. Report any residual differences in underline shape separately.

## Acceptance
Red underline under white sample text both outside and inside tmux; error underline follows DiagnosticUnderlineError color in Neovim. Sessions preserved. No other display settings changed.

## Rollback
Remove the new dotfile line, restore the pre-change terminal-features array captured before applying, and reattach the client. Removing the line and merely re-sourcing the config does not remove an already-applied server option.

Planning only: no terminal configuration changes applied.
