-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "everforest",
    -- transparency = true,
    hl_add = {
        SupermavenRunning = { fg = "#66c13e" },
    },
    hl_override = {
        Comment = { italic = true },
        ["@comment"] = { italic = true },
    },
    integrations = { "dap", "hop", "todo", "trouble", "flash", "mason", "avante", "render-markdown" },
}

M.ui = {
    cmp = {
        lspkind_text = true,
        style = "default", -- default/flat_light/flat_dark/atom/atom_colored
        icons_left = true,
        format_colors = {
            tailwind = true,
        },
    },

    telescope = { style = "borderless" }, -- borderless / bordered

    statusline = {
        -- overriden_modules = {
        --     cursor = "%#St_pos_sep#%#St_pos_icon# %#St_pos_text# %p %% ", -- 修改为百分比,默认是行/列
        -- },
        theme = "default",
        separator_style = "round",
        order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
        modules = {
            cursor = "%#St_pos_sep#%#St_pos_icon# %#St_pos_text# %p %% ", -- 修改默认cursor为百分比,默认是行/列

            supermaven = function()
                local status = require("supermaven-nvim.api").is_running()
                if status then
                    return "%#SupermavenRunning#" .. "  "
                end
                return ""
            end,
        },
    },

    lsp = { signature = true },
}

M.nvdash = {
    load_on_startup = true,
}

return M
