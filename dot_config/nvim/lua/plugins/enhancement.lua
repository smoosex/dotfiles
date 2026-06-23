return {
	{
		"folke/flash.nvim",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
		config = function()
			dofile(vim.g.base46_cache .. "flash")
			require("flash").setup({})
		end,
	},

	{
		"folke/snacks.nvim",
		opts = {
			lazygit = {},
			scroll = {},
		},
		keys = {
			{
				"<leader>lg",
				function()
					require("snacks").lazygit()
				end,
				desc = "LazyGit",
			},
			{ "gg" },
			{ "G" },
			{ "<c-d>" },
			{ "<c-u>" },
		},
	},

	{
		"kylechui/nvim-surround",
		event = "BufRead",
		opts = {},
	},

	{
		"jake-stewart/multicursor.nvim",
		keys = {
			{
				"<leader>mi",
				function()
					require("multicursor-nvim").toggleCursor()
				end,
				desc = "Multicursor: Add or remove a cursor in current",
			},
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

			mc.addKeymapLayer(function(layerSet)
				layerSet({ "n", "x" }, "<left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<right>", mc.nextCursor)
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)

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
		"nvim-pack/nvim-spectre",
		event = "BufRead",
		keys = {
			{
				mode = "n",
				"<leader>S",
				'<cmd>lua require("spectre").toggle()<CR>',
				{ desc = "Toggle Spectre" },
			},
			{
				mode = "n",
				"<leader>sw",
				'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
				{ desc = "Search current word" },
			},
			{
				mode = "v",
				"<leader>sw",
				'<esc><cmd>lua require("spectre").open_visual()<CR>',
				{ desc = "Search current word" },
			},
			{
				mode = { "n", "v" },
				"<leader>sp",
				'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
				{ desc = "Search on current file" },
			},
		},
		config = function()
			require("spectre").setup({})
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

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {},
	},

	{
		"nvzone/floaterm",
		dependencies = "nvzone/volt",
		opts = {
			terminals = {
				{ name = "Terminal" },
				{ name = "Terminal" },
			},
		},
		cmd = "FloatermToggle",
	},
}
