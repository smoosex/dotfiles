return {
	{
		"nvim-telescope/telescope.nvim",
		opts = {
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},

		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},

	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			dofile(vim.g.base46_cache .. "todo")
			require("todo-comments").setup()
		end,
	},
}
