return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {
			file_types = { "markdown", "Avante", "codecompanion" },
			heading = { icons = { "󰼏 ", "󰎨 " }, position = "inline" },
			preset = "lazy",
		},
		config = function()
			dofile(vim.g.base46_cache .. "render-markdown")
		end,
		ft = { "markdown", "Avante", "codecompanion" },
	},
}
