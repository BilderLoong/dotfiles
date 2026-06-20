return {
    "folke/lazydev.nvim",
    ft = "lua",
    enabled = false,
    opts = {
        library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
    },
}
