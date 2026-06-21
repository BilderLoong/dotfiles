## Context

AstroNvim uses AstroLSP to configure and enable LSP servers. Mason manages server installation, while AstroLSP handles server lifecycle (enable/disable). The configuration in `astrolsp.lua` has a `handlers` table that controls which servers get enabled.

Current state: The default handler `["*"] = vim.lsp.enable` is commented out (line 45), so Mason-installed servers are never enabled.

## Goals / Non-Goals

**Goals:**
- Restore automatic LSP server enablement for all Mason-installed servers
- Maintain existing AstroNvim configuration patterns
- Zero behavioral changes beyond fixing the broken LSP attachment

**Non-Goals:**
- Adding new LSP servers
- Customizing per-server settings
- Changing formatting or keybinding behavior

## Decisions

**Decision 1: Uncomment the existing handler**

Rationale: This is the minimal change that restores intended behavior. The handler pattern `["*"] = vim.lsp.enable` is documented in AstroLSP README and is the standard AstroNvim approach.

Alternative considered: Explicitly list servers in `servers = {}` table.
- Rejected: More verbose, requires manual maintenance when adding/removing servers via Mason.

**Decision 2: Use shorthand syntax**

Use `["*"] = vim.lsp.enable` instead of `["*"] = function(server) vim.lsp.enable(server) end`.
- Rationale: Cleaner, equivalent function, matches AstroLSP documentation examples.

## Risks / Trade-offs

**Risk:** All Mason-installed servers will be enabled automatically.
- **Mitigation:** This is the intended AstroNvim behavior. Individual servers can be disabled with `server_name = false` if needed.

**Risk:** Unknown why the handler was originally commented out.
- **Mitigation:** Git blame/history may reveal context. The comment appears intentional but the current behavior (no LSP at all) is clearly broken.

## Migration Plan

1. Edit `lua/plugins/astrolsp.lua` line 45
2. Uncomment: `["*"] = vim.lsp.enable,`
3. Restart Neovim or run `:Lazy reload astrolsp`
4. Verify with `:LspInfo` on a supported file type

## Open Questions

None - this is a straightforward configuration fix.
