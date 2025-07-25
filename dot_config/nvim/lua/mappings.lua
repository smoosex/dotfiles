require("nvchad.mappings")

-- Disable mappings
local nomap = vim.keymap.del
nomap("n", "<leader>gt")
nomap("n", "<leader>cm")
nomap("n", "<leader>b")

-- Custom mappings
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>ih", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end, { desc = "toggle inlay hints" })

map("n", "<leader>if", "<cmd>FloatermToggle<cr>", { desc = "toggle floatrm" })

vim.keymap.set("n", "<C-t>", function()
	require("menu").open("default")
end, {})

map("n", "<up>", function()
	require("minty.utils").lighten_on_cursor(3)
end)

map("n", "<down>", function()
	require("minty.utils").lighten_on_cursor(-3)
end)

-- mouse users + nvimtree users!
map("n", "<RightMouse>", function()
	require("menu.utils").delete_old_menus()
	-- vim.cmd.exec '"normal! G"'

	local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)

	local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"
	require("menu").open(options, { mouse = true })
end, {})

-- Telescope
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todo" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find files" })
map("n", "<leader>gm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>ga", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>cz", "<cmd>Telescope chezmoi find_files<CR>", { desc = "telescope chezmoi find_files" })

-- stylua: ignore start
-- Buffer
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer New" })
map("n", "<leader>bc", function() require("nvchad.tabufline").closeAllBufs(true) end, { desc = "Buffer Close All" })
map("n", "<leader>bC", function() require("nvchad.tabufline").closeAllBufs(false) end, { desc = "Buffer Close All Exclude Current" })
map("n", "<leader>bdh", function() require("nvchad.tabufline").closeBufs_at_direction "left" end, { desc = "Buffer Close Left" })
map("n", "<leader>bdl", function() require("nvchad.tabufline").closeBufs_at_direction "right" end, { desc = "Buffer Close Right" })
map("n", "<leader>bh", function() require("nvchad.tabufline").move_buf(-1) end, { desc = "Buffer Move Left" })
map("n", "<leader>bl", function() require("nvchad.tabufline").move_buf(1) end, { desc = "Buffer Move Right" })

-- window
map("n", "<M-Right>", "<cmd>vertical resize +5<CR>", { desc = "Increase window width" })
map("n", "<M-Left>", "<cmd>vertical resize -5<CR>", { desc = "Decrease window width" })
map("n", "<M-Up>", "<cmd>horizontal resize +5<CR>", { desc = "Decrease window width" })
map("n", "<M-Down>", "<cmd>horizontal resize -5<CR>", { desc = "Decrease window height" })

-- tab
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Tab New" })
map("n", "<leader>tj", "<cmd>tabNext<CR>", { desc = "Tab Next" })
map("n", "<leader>tk", "<cmd>tabprevious<CR>", { desc = "Tab Previous" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Tab Close" })
-- stylua: ignore end
