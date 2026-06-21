## Why

No LSP servers are attaching to buffers when opening files. Mason-installed servers (lua_ls, pyright, ts_ls, etc.) are present but never enabled.

**Root cause:** The `handlers["*"]` function in `astrolsp.lua` is commented out (line 45), preventing automatic server enablement.

## What Changes

- Uncomment the default handler in `astrolsp.lua` to enable automatic LSP server attachment
- All Mason-installed servers will now be enabled when opening matching file types

## Capabilities

### New Capabilities

None - this is a bug fix, not a new feature.

### Modified Capabilities

None - no spec-level behavior changes, just fixing broken configuration.

## Impact

- **Files modified:** `lua/plugins/astrolsp.lua` (1 line change)
- **Behavior:** All Mason-installed LSP servers will automatically attach to buffers
- **Risk:** Low - this restores the intended AstroNvim default behavior
