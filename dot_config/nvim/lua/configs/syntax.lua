local M = {
	treesitter = {
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"html",
				"css",
				"javascript",
				"json",
				"toml",
				"markdown",
				"bash",
				"go",
				"gomod",
				"gosum",
				"gotmpl",
				"gowork",
				"yaml",
				"vue",
				"python",
				"java",
				"svelte",
				"typescript",
        "c",
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
		},
		-- config = function(_, opts)
		--   require("nvim-treesitter.configs").setup(opts)
		-- end,
	},

	lspconfig = {
		"neovim/nvim-lspconfig",
		config = function()
			-- load defaults i.e lua_lsp
			require("nvchad.configs.lspconfig").defaults()

			local servers = {
				"lua_ls",
				"html",
				-- "cssls",
				"marksman",
				"pyright",
				"jdtls",
				"gopls",
				"vtsls",
				"vue_ls",
				"tailwindcss",
				"svelte",
        "clangd",
			}

			vim.lsp.config("gopls", {
				settings = {
					gopls = { analyses = { modernize = false } },
				},
			})

			vim.lsp.config("vtsls", {
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"vue",
				},
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								{
									name = "@vue/typescript-plugin",
									location = "/Users/smoose/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server",
									languages = { "vue" },
									configNamespace = "typescript",
									enableForWorkspaceTypeScriptVersions = true,
								},
							},
						},
					},
				},
			})

			vim.lsp.config("vue_ls", {
				on_init = function(client)
					client.handlers["tsserver/request"] = function(_, result, context)
						local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
						if #clients == 0 then
							vim.notify(
								"Could not found `vtsls` lsp client, vue_lsp would not work without it.",
								vim.log.levels.ERROR
							)
							return
						end
						local ts_client = clients[1]

						local param = unpack(result)
						local id, command, payload = unpack(param)
						ts_client:exec_cmd({
							title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
							command = "typescript.tsserverRequest",
							arguments = {
								command,
								payload,
							},
						}, { bufnr = context.bufnr }, function(_, r)
							local response_data = { { id, r.body } }
							---@diagnostic disable-next-line: param-type-mismatch
							client:notify("tsserver/response", response_data)
						end)
					end
				end,
			})

			vim.lsp.enable(servers)
		end,
	},

	conform = {
		"stevearc/conform.nvim",
		-- event = "BufWritePre",
		opts = {
			-- custom formatter
			formatters = {
				["goimports-reviser"] = {
					prepend_args = {
						-- "-rm-unused",
						-- "-format",
						"-separate-named",
						"-imports-order",
						"std,project,general,company,blanked,dotted",
					},
				},
				golines = {
					prepend_args = {
						"--max-len=128",
					},
				},
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},

			formatters_by_ft = {
				lua = { "stylua" },

				-- webdev
				javascript = { "biome" },
				javascriptreact = { "biome" },
				typescript = { "prettier" },
				typescriptreact = { "biome" },
				vue = { "prettier" },
				svelte = { "deno_fmt" },
				json = { "biome" },
				jsonc = { "biome" },

				css = { "biome" },
				html = { "prettier" },

				sh = { "shfmt" },
				yaml = { "yamlfmt" },
				toml = { "taplo" },

				go = { "goimports", "goimports-reviser" },
				python = { "black" },
				java = { "google-java-format" },

				["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
			},

			-- format_on_save = {
			--     -- These options will be passed to conform.format()
			--     timeout_ms = 5000,
			--     lsp_fallback = true,
			-- },
		},

		keys = {
			{
				mode = "n",
				"<leader>fgl",
				function()
					require("conform").format({
						formatters = { "goimports", "golines", "goimports-reviser" },
						timeout_ms = 5000,
					})
				end,
				desc = "Format go file with golines",
			},
		},
	},

	trouble = {
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>tX",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>tx",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>ts",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>tL",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>tL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>tQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
		config = function()
			dofile(vim.g.base46_cache .. "trouble")
			require("trouble").setup()
		end,
	},

	parinfer = {
		"gpanders/nvim-parinfer",
		event = "InsertEnter",
	},

	ts_context_comment = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
}

return M
