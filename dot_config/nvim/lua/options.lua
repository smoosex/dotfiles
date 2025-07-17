require("nvchad.options")

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.splitkeep = "screen"

-- o.shell = "/opt/homebrew/bin/fish"

-- Indenting
-- o.shiftwidth = 2
-- o.tabstop = 2
-- o.softtabstop = 2
-- o.autoindent = true
-- o.smartindent = true
-- o.expandtab = true

-- onlu work in gui
-- o.linespace =

-- o.foldmethod = "indent"
-- o.foldlevel = 99
-- local wilder = require('wilder')
-- wilder.setup({modes = {':', '/', '?'}})
--
-- views can only be fully collapsed with the global statusline
-- 0: Hide the status bar entirely
-- 1: Show the status bar only in multiple windows
-- 2: Always show the status bar(each window has its own status bar)
-- 3: Always show the global status bar(the entire editor has only one status bar)
vim.opt.laststatus = 3

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldlevel = 99
