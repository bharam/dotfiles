return {
    "gbprod/yanky.nvim",
    event = "BufRead",
    keys = {
        { "y", "<Plug>(YankyYank)", { "n", "x" }, desc = "Yank" },
        { "p", "<Plug>(YankyPutAfter)", desc = "Paste After" },
        { "P", "<Plug>(YankyPutBefore)", desc = "Paste Before" },
        { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Paste Below" },
        { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Paste Above" },
    },
    opts = {
        ring = {
            history_length = 3,
            sync_with_numbered_register = true,
        },
        highlight = {
            on_put = false,
            on_yank = false,
        },
    },
}
