-- hex, rgb color highlighter
return {
    "NvChad/nvim-colorizer.lua", -- fork from norcalli/nvim-colorizer.lua
    event = "VeryLazy",
    opts = {
        filetypes = { "*" },
        user_default_options = {
            RGB = false, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            names = false, -- "Name" codes like Blue or blue
            RRGGBBAA = false, -- #RRGGBBAA hex codes
            AARRGGBB = false, -- 0xAARRGGBB hex codes
            rgb_fn = false, -- CSS rgb() and rgba() functions
            hsl_fn = false, -- CSS hsl() and hsla() functions
            css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            -- Available modes for `mode`: foreground, background,  virtualtext
            mode = "background", -- Set the display mode.
            -- Available methods are false / true / "normal" / "lsp" / "both"
            -- True is same as normal
            tailwind = false, -- Enable tailwind colors
            -- parsers can contain values used in |user_default_options|
            sass = { enable = false, parsers = { css = true } }, -- Enable sass colors
            virtualtext = "■",
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
    },
}

-- red, blue, green, yellow,
-- #A3BE8C
-- #123
