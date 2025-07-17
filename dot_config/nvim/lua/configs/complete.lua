local M = {
	cmp = {
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"supermaven-inc/supermaven-nvim",
				opts = {},
			},
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
			version = "*",
			opts = {
				keymap = {
					["<CR>"] = { "accept", "fallback" },
					["<S-Tab>"] = { "select_prev", "fallback" },
					["<Tab>"] = { "select_next", "fallback" },
					["<C-b>"] = { "scroll_documentation_up", "fallback" },
					["<C-f"] = { "scroll_documentation_down", "fallback" },
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
}

return M
