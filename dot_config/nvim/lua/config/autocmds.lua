local augroup = function(name) return vim.api.nvim_create_augroup("HRB_" .. name, { clear = true }) end

-- format options
vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup("FormatOptions"),
    callback = function() vim.bo.formatoptions = "cqnlj" end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd("VimResized", {
    group = augroup("ResizeSplits"),
    callback = function() vim.cmd("tabdo wincmd =") end,
})

-- close some filetypes with `q`
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("CloseQ"),
    pattern = {
        "git",
        "fugitive",
        "qf",
        "help",
        "man",
        "query", -- tree-sitter playground
        "lspinfo",
        "startuptime",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- open some filetypes on vertical split
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("VertSplit"),
    pattern = { "help", "fugitive", "git" },
    callback = function()
        if vim.fn.winwidth(0) / 2 > 80 then
            vim.cmd.wincmd("L")
        else
            vim.cmd.wincmd("J")
        end
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("AutoCreateDir"),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- auto add config files to chezmoi source
vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup("ChezmoiAdd"),
    pattern = { vim.env.XDG_CONFIG_HOME .. "/**/*" },
    ---@param ev { file: string, match: string }
    callback = function(ev)
        local result = vim.fn.system({ "chezmoi", "add", ev.match })
        if vim.v.shell_error == 0 then
            vim.notify("Chezmoi added: " .. ev.file)
        else
            vim.notify("Chezmoi add failed: " .. result, vim.log.levels.WARN)
        end
    end,
})

-- auto apply config files to target path
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup("ChezmoiApply"),
    pattern = { vim.env.CHEZMOI_SOURCE .. "/**/*" },
    ---@param ev { file: string, match: string }
    callback = function(ev)
        if ev.file:match("COMMIT_EDITMSG") then
            vim.notify("Commit message, not applying")
            return
        end
        local result = vim.fn.system({ "chezmoi", "apply", "--source-path", ev.match })
        if vim.v.shell_error == 0 then
            vim.notify("Chezmoi applied: " .. ev.file)
        else
            vim.notify("Chezmoi apply failed: " .. result, vim.log.levels.WARN)
        end
    end,
})

-- Tab configuration
---@diagnostic disable-next-line: unused-local, unused-function
-- local function set_tabstop(size)
--     vim.opt_local.tabstop = size
--     vim.opt_local.softtabstop = size
--     vim.opt_local.shiftwidth = size
-- end
-- vim.api.nvim_create_autocmd("FileType", {
--     group = augroup("TabTwo"),
--     pattern = { "typescript", "javascript", "css", "html", "svelte" },
--     callback = function() set_tabstop(2) end,
-- })

-- wrap text
-- vim.api.nvim_create_autocmd("FileType", {
--     group = augroup("Wrap"),
--     pattern = { "markdown" },
--     callback = function() vim.opt_local.wrap = true end,
-- })
