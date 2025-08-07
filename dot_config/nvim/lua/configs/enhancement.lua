local M = {
	flash = {
		"folke/flash.nvim",
		opts = {},
        -- stylua: ignore
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
		config = function()
			dofile(vim.g.base46_cache .. "flash")
			require("flash").setup({
				-- your custom config here (optional)
			})
		end,
	},

	snack = {
		"folke/snacks.nvim",
		-- priority = 1000,
		opts = {
			image = {},
			lazygit = {},
			scroll = {},
		},
		keys = {
      -- stylua: ignore start 
      { "<leader>lg", function() require("snacks").lazygit() end, desc = "LazyGit", },
      {"gg"},
      {"G"},
      { "<c-d>"},
      {"<c-u>" },
			-- stylua: ignore end
		},
	},

	surround = {
		"kylechui/nvim-surround",
		event = "BufRead",
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					insert = false,
					insert_line = false,
					normal = false,
					normal_cur = false,
					normal_line = false,
					normal_cur_line = false,
					visual = "ss",
					visual_line = "sl",
					delete = "ds",
					change = "cs",
					change_line = "cl",
				},
			})
		end,
	},

	multicursor = {
		"jake-stewart/multicursor.nvim",
		keys = {
			-- -- Add cursor in current cursor
			{
				"<leader>mi",
				function()
					require("multicursor-nvim").toggleCursor()
				end,
				desc = "Multicursor: Add or remove a cursor in current",
			},
			-- -- Add or skip cursor above/below the main cursor
			{
				mode = { "n", "x" },
				"<leader>mk",
				function()
					require("multicursor-nvim").lineAddCursor(-1)
				end,
				desc = "Multicursor: Add cursor above the main cursor",
			},
			{
				mode = { "n", "x" },
				"<leader>mj",
				function()
					require("multicursor-nvim").lineAddCursor(1)
				end,
				desc = "Multicursor: Add cursor below the main cursor",
			},
			{
				mode = { "n", "x" },
				"<leader>msk",
				function()
					require("multicursor-nvim").lineSkipCursor(-1)
				end,
				desc = "Multicursor: Skip cursor above the main cursor",
			},
			{
				mode = { "n", "x" },
				"<leader>lsj",
				function()
					require("multicursor-nvim").lineSkipCursor(1)
				end,
				desc = "Multicursor: Skip cursor below the main cursor",
			},
			-- Add or skip adding a new cursor by matching word/selection
			{
				mode = { "n", "x" },
				"<leader>mw",
				function()
					require("multicursor-nvim").matchAddCursor(1)
				end,
				desc = "AMulticursor: dd adding a new cursor by next matching word/selection",
			},
			{
				mode = { "n", "x" },
				"<leader>msw",
				function()
					require("multicursor-nvim").matchSkipCursor(1)
				end,
				desc = "Multicursor: Skip adding a new cursor next by matching word/selection",
			},
			{
				mode = { "n", "x" },
				"<leader>mW",
				function()
					require("multicursor-nvim").matchAddCursor(-1)
				end,
				desc = "Multicursor: Add adding a new cursor by previous matching word/selection",
			},
			{
				mode = { "n", "x" },
				"<leader>msW",
				function()
					require("multicursor-nvim").matchSkipCursor(-1)
				end,
				desc = "Multicursor: Skip adding a new cursor by previous matching word/selection",
			},
			-- Add and remove cursors with control + left click.
			{
				"<c-leftmouse>",
				function()
					require("multicursor-nvim").handleMouse()
				end,
			},
			{
				"<c-leftdrag>",
				function()
					require("multicursor-nvim").handleMouseDrag()
				end,
			},
			{
				"<c-leftrelease>",
				function()
					require("multicursor-nvim").handleMouseRelease()
				end,
			},
		},
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			-- Mappings defined in a keymap layer only apply when there are
			-- multiple cursors. This lets you have overlapping mappings.
			mc.addKeymapLayer(function(layerSet)
				-- Select a different cursor as the main one.
				layerSet({ "n", "x" }, "<left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<right>", mc.nextCursor)

				-- Delete the main cursor.
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

				-- Enable and clear cursors using escape.
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)

			-- Customize how cursors look.
			local hl = vim.api.nvim_set_hl
			hl(0, "MultiCursorCursor", { link = "Cursor" })
			hl(0, "MultiCursorVisual", { link = "Visual" })
			hl(0, "MultiCursorSign", { link = "SignColumn" })
			hl(0, "MultiCursorMatchPreview", { link = "Search" })
			hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
			hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},

	{
		"rachartier/tiny-glimmer.nvim",
		keys = { "u", "<c-r>" },
		opts = {
			overwrite = {
				redo = {
					enabled = true,
					default_animation = {
						settings = {
							from_color = "DiffAdd",
						},
					},
				},

				undo = {
					enabled = true,
					default_animation = {
						settings = {
							from_color = "DiffDelete",
						},
					},
				},
			},
		},
	},

	spectre = {
		"nvim-pack/nvim-spectre",
		event = "BufRead",
		keys = {
			{
				mode = "n",
				"<leader>S",
				'<cmd>lua require("spectre").toggle()<CR>',
				{
					desc = "Toggle Spectre",
				},
			},
			{
				mode = "n",
				"<leader>sw",
				'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
				{
					desc = "Search current word",
				},
			},
			{
				mode = "v",
				"<leader>sw",
				'<esc><cmd>lua require("spectre").open_visual()<CR>',
				{
					desc = "Search current word",
				},
			},
			{
				mode = { "n", "v" },
				"<leader>sp",
				'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
				{
					desc = "Search on current file",
				},
			},
		},
		config = function()
			require("spectre").setup({})
		end,
	},

	glimmer = {
		"rachartier/tiny-glimmer.nvim",
		keys = { "u", "<c-r>" },
		opts = {
			overwrite = {
				redo = {
					enabled = true,
					default_animation = {
						settings = {
							from_color = "DiffAdd",
						},
					},
				},

				undo = {
					enabled = true,
					default_animation = {
						settings = {
							from_color = "DiffDelete",
						},
					},
				},
			},
		},
	},

	zen = {
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {}
	},

	floaterm = {
		"nvzone/floaterm",
		dependencies = "nvzone/volt",
		opts = {
			terminals = {
				{ name = "Terminal" },
				-- cmd can be function too
				{ name = "Terminal" },
				-- More terminals
			},
		},
		cmd = "FloatermToggle",
	},

	im_select = {
		"SilverofLight/im-select.nvim",
		event = "VeryLazy",
		config = function()
			require("im_select").setup({
				hybrid_mode = true,
			})
		end,
	},

	hahrdtime = {
		"m4xshen/hardtime.nvim",
		cmd = "Hardtime",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			max_count = 30,
		},
	},
}

return M
