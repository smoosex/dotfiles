local M = {
	gitsigns = {
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		opts = {
			current_line_blame = true,

			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Git Next Hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Git Prev Hunk" })

				-- Actions
				map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Git Stage Hunk" })
				map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Git Undo Stage Hunk" })
				map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Git Reset Hunk" })

				map("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)

				map("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)

				map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Git Stage Buffer" })
				map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Git Reset Buffer" })
				map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Git Preview Hunk" })
				map("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "Git Preview Hunk Inline" })

				map("n", "<leader>gb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "Git Blame Line" })
				map("n", "<leader>gB", function()
					gitsigns.blame()
					local win = vim.api.nvim_get_current_win()
					local b = vim.api.nvim_get_current_buf()
					vim.keymap.set("n", "q", function()
						vim.api.nvim_win_close(win, false)
					end, { buffer = b, noremap = true, silent = true })
				end, { desc = "Git Blame" })

				-- map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git Diff This" })
				--
				-- map("n", "<leader>gD", function()
				-- 	gitsigns.diffthis("~")
				-- end, { desc = "Git Diff This ~" })

				map("n", "<leader>gQ", function()
					gitsigns.setqflist("all")
				end, { desc = "Git Set Quickfixlist for Whole Buffer" })
				map("n", "<leader>gq", gitsigns.setqflist, { desc = "Git Set Quickfixlist" })

				-- Toggles
				map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Git Toggle Current Line Blame" })
				map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "Git Toggle Deleted" })
				map("n", "<leader>gtw", gitsigns.toggle_word_diff, { desc = "Git Toggle Word Diff" })
				map("n", "<leader>gtl", gitsigns.toggle_linehl, { desc = "Git Toggle Hightlight Add Line" })

				-- Text object
				map({ "o", "x" }, "ih", gitsigns.select_hunk)
			end,
		},
	},
	diffview = {
		"sindrets/diffview.nvim",
		event = "User FilePost",
		keys = {
		    -- stylua: ignore start
		    { mode = "n", "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open", },
		    { mode = "n", "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close", },
		    { mode = "n", "<leader>gdf", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History", },
		    { mode = "n", "<leader>gdF", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "Diffview Current File History", },
		    { mode = "v", "<leader>gds", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", desc = "Diffview Selected Content History", },
		    { mode = "n", "<leader>gdl", "<Cmd>.DiffviewFileHistory --follow<CR>", desc = "Diffview Single Line History", },
			-- stylua: ignore end
		},
	},
}

return M
