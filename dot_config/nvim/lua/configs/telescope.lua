local M = {
	telescope = {
		"nvim-telescope/telescope.nvim",
		opts = {
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},

				-- media = { backend = "ueberzug" },
			},
		},

		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			-- "2kabhishek/nerdy.nvim",
			-- "dharmx/telescope-media.nvim",
		},
	},

	todo_comments = {
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			dofile(vim.g.base46_cache .. "todo")
			require("todo-comments").setup()
		end,
	},
}

return M
