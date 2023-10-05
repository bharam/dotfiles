---@diagnostic disable: need-check-nil
return {
    "goolord/alpha-nvim",
    -- enabled = false,
    event = "VimEnter",
    priority = 30, -- lower priority than persisted.nvim
    config = function()
        local alpha = require("alpha")

        local function hl_random()
            -- local wday = os.date("*t").wday
            local colors = {
                "DiagnosticInfo", -- teal
                "Type", -- skyblue
                -- "DiagnosticHint", -- blue
                "Number", -- magenta
                -- "DiagnosticError", -- red
                -- "Decorator", -- orange
                "DiagnosticWarn", -- yellow
                "String", -- green
                "RustEnum", -- emerald
                "Identifier", -- white
            }
            math.randomseed(os.time())
            local index = math.random(#colors)
            return colors[index]
        end

        local header = {
            type = "text",
            val = {
                [[  ██████   █████                   █████   █████  ███                  ]],
                [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
                [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
                [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
                [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
                [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
                [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
                [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
            },
            opts = {
                position = "center",
                hl = hl_random(),
            },
        }

        local function info_text()
            local total_plugins = require("lazy").stats().count
            local datetime = os.date(" %Y-%m-%d %A")
            local version = vim.version()
            local nightly = version.prerelease == true and "-nightly" or ""
            local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch .. nightly
            return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
        end
        local info = {
            type = "text",
            val = info_text(),
            opts = {
                hl = "Comment",
                position = "center",
            },
        }

        local function shortcut_text()
            local keybind_opts = { silent = true, noremap = true }
            vim.api.nvim_create_autocmd({ "User" }, {
                pattern = { "AlphaReady" },
                callback = function(_)
                    vim.api.nvim_buf_set_keymap(0, "n", "n", "<cmd>enew<cr>", keybind_opts)
                    vim.api.nvim_buf_set_keymap(0, "n", "e", "<cmd>NvimTreeToggle<CR>", keybind_opts)
                    vim.api.nvim_buf_set_keymap(0, "n", "s", "<cmd>e $MYVIMRC<CR>", keybind_opts)
                    vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>q<cr>", keybind_opts)
                end,
            })
            return {
                {
                    type = "text",
                    val = {
                        " New File [n]     File Tree [e]     Settings [s]     Quit [q]",
                    },
                    opts = {
                        position = "center",
                        hl = {
                            { "Function", 0, 20 }, -- emerald
                            { "Type", 20, 40 }, -- teal
                            { "DiagnosticHint", 40, 60 }, -- skyblue
                            { "Number", 60, 80 }, -- blue
                        },
                    },
                },
            }
        end
        local shortcuts = { type = "group", val = shortcut_text() }

        local function button(lhs, rhs, text, keybind_opts)
            local opts = {
                position = "center",
                shortcut = lhs,
                cursor = 3, --0,
                width = 45,
                align_shortcut = "right",
                hl = {
                    { hl_random(), 0, 3 },
                    -- { hl_random(), 20, 40 }, -- hi shortcut hint
                },
                keymap = { "n", lhs, rhs, keybind_opts },
            }
            local function on_press()
                local key = vim.api.nvim_replace_termcodes(rhs .. "<Ignore>", true, false, true)
                vim.api.nvim_feedkeys(key, "t", false)
            end
            return {
                type = "button",
                val = text,
                on_press = on_press,
                opts = opts,
            }
        end
        local buttons = {
            type = "group",
            val = {
                button("f", "<cmd>Telescope find_files<cr>", "  Find Files", {}),
                button("p", "<cmd>Telescope live_grep<cr>", "  Live Grep", {}),
                button("o", "<cmd>Telescope oldfiles<cr>", "  Recent Files", {}),
                button("s", "<cmd>Telescope persisted<cr>", "  Sessions", {}),
                button("l", "<cmd>SessionLoad<cr>", "  Sessions", {}),
                button("t", "<cmd>TodoTelescope<cr>", "  Todo Items", {}),
            },
            opts = {
                spacing = 1,
            },
        }

        local config = {
            layout = {
                { type = "padding", val = 8 },
                header,
                { type = "padding", val = 2 },
                shortcuts,
                { type = "padding", val = 1 },
                info,
                { type = "padding", val = 2 },
                buttons,
            },
        }

        alpha.setup(config)
    end,
}

-- reference
-- https://github.com/AllanChain/custom-chad/blob/main/plugins/alpha.lua

-- "███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
-- "████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
-- "██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
-- "██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
-- "██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
-- "╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",

-- [[                         .^!^                                           .!~:                        ]],
-- [[                    ^!JPB&B!.                                            !&&BPJ!:                   ]],
-- [[                ^?P#@@@@@G.                   :       :                   !@@@@@&BY!:               ]],
-- [[             ^JB@@@@@@@@@7                   .#~     ?P                   .&@@@@@@@@&G?:            ]],
-- [[          .7G@@@@@@@@@@@@#!                  ?@#^   ~@@^                 .5@@@@@@@@@@@@@G7.         ]],
-- [[        .?#@@@@@@@@@@@@@@@@BY!^.             B@@&BBB&@@Y              :~Y&@@@@@@@@@@@@@@@@#?.       ]],
-- [[       !#@@@@@@@@@@@@@@@@@@@@@@#G5Y?!~^:..  !@@@@@@@@@@#.   ..::^!7J5B&@@@@@@@@@@@@@@@@@@@@@B!      ]],
-- [[     .5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&##B#@@@@@@@@@@@BBBB##&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y     ]],
-- [[    :B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5    ]],
-- [[   .B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?   ]],
-- [[   5@&#BGGPPPPPGGB&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BGGPP5PPPGBB#&#.  ]],
-- [[   ^:..           .^!YB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&57^.            .:^.  ]],
-- [[                       ~G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y.                      ]],
-- [[                         P@@@#BGGGGB#@@@@@@@@@@@@@@@@@@@@@@@@@#BP5555PG#@@@P                        ]],
-- [[                         :J!:.      .^!JG&@@@@@@@@@@@@@@@@#57^.        .:!5~                        ]],
-- [[                                         :?G@@@@@@@@@@@@P!.                                         ]],
-- [[                                            ~5@@@@@@@@5^                                            ]],
-- [[                                              ^P@@@@G^                                              ]],
-- [[                                                !#@?                                                ]],
-- [[                                                 :^ ]],
--

-- ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣴⣶⠶⠶⠶⠶⠶⢶⠶⠶⠲⠶⠶⠶⠶⠶⡶⢶⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⣤⣾⠟⠋⠉⣀⣀⣤⣴⣶⣶⣶⣿⣿⣿⣿⢿⠿⠿⠿⠷⠶⣭⣭⣍⣛⠫⠝⠻⢷⣦⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⡷⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⠆⠀⠀⠘⠻⢿⣉⣻⣶⣾⢿⠃⠀⣀⡀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⡇⠀⠉⠙⠛⠻⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⠿⢿⣛⡛⠉⠀⢸⠛⠛⢿⠛⢿⣦⡀
-- ⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⢀⡀⠀⢁⣀⣘⣻⣍⡭⣥⣤⠀⠀⡀⣼⠖⠒⠉⠙⡞⡜⣷
-- ⠀⠀⠀⠀⠀⠀⢿⠰⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠢⣄⠀⠠⠽⡤⢾⠾⢰⢡⢤⡿⠀⠀⠀⢠⣧⡇⡟
-- ⠀⠀⠀⠀⠀⠀⢸⡖⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠠⢷⠼⠀⡆⡜⣾⡇⠀⠀⢀⡜⢻⣷⠇
-- ⠀⠀⠀⠀⠀⠀⠀⢧⣧⢱⠈⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠈⠀⡜⢰⢡⣿⠁⠀⣠⠞⣠⣿⠋⠀
-- ⠀⠀⠀⠀⠀⠀⢀⣸⣟⡄⢇⢰⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⢀⡼⢡⣷⢻⡧⠔⢋⣥⣾⠟⠁⠀⠀
-- ⠀⠀⣠⣴⠞⣋⣩⠤⠿⣝⡌⣆⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣧⡤⣴⠏⣠⣿⣻⡏⣀⣺⣿⠿⢥⡀⠀⠀⠀
-- ⢠⡞⠁⡴⠛⠉⠀⠀⠀⠙⢮⠈⢢⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡞⠁⣴⣿⡿⠋⢩⠁⡈⠉⡳⡄⢹⣦⠀⠀
-- ⠸⣦⡆⢷⣀⠀⢠⣄⣀⠀⠀⠓⢄⣁⠀⠀⠀⠀⠀⠀⠀⠀⠠⠴⠿⠿⠟⠓⠀⣴⡿⠟⠁⠠⣞⣡⢃⣤⣷⢏⣼⡿⠀⠀
-- ⠀⠈⠓⠮⣿⣿⣶⣿⣿⣿⣿⣶⣤⣈⣙⠒⠲⠦⠤⠤⠴⠿⠿⠿⠿⠯⠥⠖⢒⣉⣤⣤⣶⠿⠿⠟⢻⣿⠿⠟⠉⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠙⠯⣝⣛⠻⠿⠤⢬⣉⣉⣉⣉⣿⣟⣛⣛⣾⣿⣿⣿⣿⣯⣍⣉⣩⣤⣤⣴⣶⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠓⠒⠲⠤⠤⠴⠧⠾⠦⣤⣬⣬⣤⣤⠤⠤⠼⠦⠬⠿⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

-- ░░  25%
-- ▒▒  50%
-- ▓▓  75%
-- nf-ple
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 

-- 7-8 x 5
-- ██╗      █████╗ ███████╗██╗   ██╗          Z
-- ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝      Z
-- ██║     ███████║  ███╔╝  ╚████╔╝    z
-- ██║     ██╔══██║ ███╔╝    ╚██╔╝   z
-- ███████╗██║  ██║███████╗   ██║
-- ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝

-- 7-8 x 5
-- ██╗   ██╗ ██████╗  ██████╗   █████╗   █████   █████  ██████   ██████   █████
-- ██║   ██║ ██╔══██╗ ██╔══██╗ ██╔══██╗ ██   ██ ██      ██   ██ ██    ██ ██
-- ████████║ ██████╔╝ ██████╔╝ ███████║ ██      ██      ██   ██ ██    ██ ██
-- ██╔═══██║ ██╔══██╗ ██╔══██╗ ██╔══██║ ██   ██ ██      ██   ██ ██    ██ ██   ██
-- ██║   ██║ ██║  ██║ ██████╔╝ ██║  ██║  █████   █████  ██████   ██████   ████ █
-- ╚═╝   ╚═╝ ╚═╝  ╚═╝ ╚═════╝  ╚═╝  ╚═╝

--  8 x 7
-- ██╗   ██╗ ███████╗  ███████╗
-- ██║   ██║ ██╔═══██╗ ██╔═══██╗
-- ██║   ██║ ██║   ██║ ██║   ██║
-- ████████║ ███████╔╝ ███████╔╝
-- ██╔═══██║ ██╔═══██╗ ██╔═══██╗
-- ██║   ██║ ██║   ██║ ██║   ██║
-- ██║   ██║ ██║   ██║ ███████╔╝
-- ╚═╝   ╚═╝ ╚═╝   ╚═╝ ╚══════╝

-- 11 x 9
-- ███╗     ███╗ ██████████╗   ██████████╗
-- ███║     ███║ ███╔════███╗  ███╔════███╗
-- ███║     ███║ ███║    ╚███╗ ███║    ╚███╗
-- ███║     ███║ ███║    ███╔╝ ███║    ███╔╝
-- ████████████║ ██████████╔╝  ██████████╔╝
-- ███╔═════███║ ███╔══███╔╝   ███╔════███╗
-- ███║     ███║ ███║  ╚███╗   ███║    ╚███╗
-- ███║     ███║ ███║   ╚███╗  ███║    ███╔╝
-- ███║     ███║ ███║    ╚███╗ ██████████╔╝
-- ╚══╝     ╚══╝ ╚══╝     ╚══╝ ╚═════════╝

-- 13 x 9
-- ███╗      ███╗ ███████████╗   ███████████╗
-- ███║      ███║ ███╔═════███╗  ███╔═════███╗
-- ███║      ███║ ███║     ╚███╗ ███║     ╚███╗
-- ███║      ███║ ███║     ███╔╝ ███║     ███╔╝
-- █████████████║ ███████████╔╝  ███████████╔╝
-- ███╔══════███║ ███╔═══███╔╝   ███╔═════███╗
-- ███║      ███║ ███║   ╚███╗   ███║     ╚███╗
-- ███║      ███║ ███║    ╚███╗  ███║     ███╔╝
-- ███║      ███║ ███║     ╚███╗ ███████████╔╝
-- ╚══╝      ╚══╝ ╚══╝      ╚══╝ ╚══════════╝

-- 13 x 11
-- ███╗      ███╗ ███████████╗   ███████████╗
-- ███║      ███║ ███╔═════███╗  ███╔═════███╗
-- ███║      ███║ ███║     ╚███╗ ███║     ╚███╗
-- ███║      ███║ ███║      ███║ ███║      ███║
-- ███║      ███║ ███║     ███╔╝ ███║     ███╔╝
-- █████████████║ ███████████╔╝  ███████████╔╝
-- ███╔══════███║ ███╔═══███╔╝   ███╔═════███╗
-- ███║      ███║ ███║   ╚███╗   ███║     ╚███╗
-- ███║      ███║ ███║    ╚███╗  ███║      ███║
-- ███║      ███║ ███║     ╚███╗ ███║     ███╔╝
-- ███║      ███║ ███║      ███║ ███████████╔╝
-- ╚══╝      ╚══╝ ╚══╝      ╚══╝ ╚══════════╝

-- 14 x 9
-- ███      ███  ███████████    ███████████
-- ███▒     ███▒ ███▒▒▒▒▒▒███   ███▒▒▒▒▒▒███
-- ███▒     ███▒ ███▒      ███  ███▒      ███
-- ███▒     ███▒ ███▒      ███▒ ███▒      ███▒
-- ███▒     ███▒ ███▒     ███▒▒ ███▒     ███▒▒
-- ████████████▒ ███████████▒▒  ███████████▒▒
-- ███▒▒▒▒▒▒███▒ ███▒▒▒▒███▒▒   ███▒▒▒▒▒▒███
-- ███▒     ███▒ ███▒    ███    ███▒      ███
-- ███▒     ███▒ ███▒     ███   ███▒      ███▒
-- ███▒     ███▒ ███▒      ███  ███▒     ███▒▒
-- ███▒     ███▒ ███▒      ███▒ ███████████▒▒
--  ▒▒▒      ▒▒▒  ▒▒▒       ▒▒▒  ▒▒▒▒▒▒▒▒▒▒▒
