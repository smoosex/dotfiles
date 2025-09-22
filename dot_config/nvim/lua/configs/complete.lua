local M = {
	cmp = {
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				-- snippet plugin
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

		-- opts = function(_, opts)
		-- 	opts.sources[1].trigger_characters = { "-" }
		-- 	table.insert(opts.sources, 1, { name = "supermaven" })
		-- end,
	},

	blink = {
		{ import = "nvchad.blink.lazyspec" },
		{
			"saghen/blink.cmp",
			dependencies = {
				"Kaiser-Yang/blink-cmp-avante",
			},
			version = "*",
			opts = {
				sources = {
					-- Add 'avante' to the list
					default = { "avante", "lsp", "snippets", "buffer", "path" },
					providers = {
						avante = {
							module = "blink-cmp-avante",
							name = "Avante",
							opts = {
								-- options for blink-cmp-avante
							},
						},
					},
				},
			},
		},
	},

	ninetyfive = {
		"ninetyfive-gg/ninetyfive.nvim",
		event = "InsertEnter",
		config = function()
			require("ninetyfive").setup({
				enable_on_startup = true, -- Enable plugin on startup
				mappings = {
					enable = true, -- Enable default keybindings
					accept = "<C-f>", -- Change default keybindings
					reject = "<C-w>", -- Change default keybindings
				},
			})
		end,
	},

	supermaven = {
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		opts = {},
	},
}

return M
