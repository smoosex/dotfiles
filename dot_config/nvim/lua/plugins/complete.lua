return {
	{
		enable = false,
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				config = function(_, opts)
					require("luasnip").config.set_config(opts)

					local luasnip = require("luasnip")

					luasnip.filetype_extend("javascriptreact", { "html" })
					luasnip.filetype_extend("typescriptreact", { "html" })
					luasnip.filetype_extend("svelte", { "html" })

					require("nvchad.configs.luasnip")
				end,
			},

			{
				"hrsh7th/cmp-cmdline",
				event = "CmdlineEnter",
				config = function()
					local cmp = require("cmp")

					cmp.setup.cmdline("/", {
						mapping = cmp.mapping.preset.cmdline(),
						sources = { { name = "buffer" } },
					})

					cmp.setup.cmdline(":", {
						mapping = cmp.mapping.preset.cmdline(),
						sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
						matching = { disallow_symbol_nonprefix_matching = false },
					})
				end,
			},
		},
	},

	{ import = "nvchad.blink.lazyspec" },
	{
		"saghen/blink.cmp",
		version = "*",
		opts = {
			sources = {
				default = { "lsp", "snippets", "buffer", "path" },
			},
		},
	},

	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		opts = {},
	},
}
