local M = {
	peek = {
		"toppair/peek.nvim",
		ft = "markdown",
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup()
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
		keys = {
			{
				"<leader>mo",
				function()
					require("peek").open()
				end,
				desc = "Peek Open",
			},
			{
				"<leader>mc",
				function()
					require("peek").close()
				end,
				desc = "Peek Close",
			},
		},
	},

	markdown_preview = {
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	render_markdown = {
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

return M
