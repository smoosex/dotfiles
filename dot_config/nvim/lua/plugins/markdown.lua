return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {
			file_types = { "markdown" },
			heading = { icons = { "󰼏 ", "󰎨 " }, position = "inline" },
			preset = "lazy",
		},
		config = function()
			dofile(vim.g.base46_cache .. "render-markdown")
		end,
		ft = { "markdown", "Avante", "codecompanion" },
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}
