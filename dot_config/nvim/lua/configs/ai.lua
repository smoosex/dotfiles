local M = {
	avante = {
		"yetone/avante.nvim",
		keys = {
			{ "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Ask a question using Avante" },
		},
		version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
		-- cmd = { "AvanteAsk" },
		opts = {
			provider = "gemini-cli",
			behaviour = {
				enable_cursor_planning_mode = false, -- enable cursor planning mode!
			},
			providers = {
				deepseek = {
					__inherited_from = "openai",
					api_key_name = "DEEPSEEK_API_KEY",
					endpoint = "https://api.deepseek.com",
					model = "deepseek-coder",
				},
				gemini = {
					endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
					model = "gemini-2.5-pro",
					timeout = 30000, -- Timeout in milliseconds
					context_window = 1048576,
					use_ReAct_prompt = true,
					extra_request_body = {
						generationConfig = {
							temperature = 0.75,
						},
					},
				},
			},
			-- mcp
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			-- Using function prevents requiring mcphub before it's loaded
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
		},
		dependencies = {
			{
				"stevearc/dressing.nvim",
				opts = {
					input = {
						enabled = false,
					},
				},
			},
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"ravitemer/mcphub.nvim",
		},

		config = function(_, opts)
			dofile(vim.g.base46_cache .. "avante")
			require("avante").setup(opts)
		end,

		build = "make",
	},

	codecompanion = {
		"olimorris/codecompanion.nvim",
		cmd = "CodeCompanionChat",
		opts = {
			strategies = {
				chat = {
					adapter = "deepseek",
				},
				inline = {
					adapter = "deepseek",
				},
				cmd = {
					adapter = "deepseek",
				},
			},
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("deepseek", {
						env = {
							api_key = "DEEPSEEK_API_KEY",
						},
					})
				end,
			},
			opts = {
				language = "Chinese",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},

	mcphub = {
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
		},
		cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
		build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
		config = function()
			require("mcphub").setup({
				extensions = {
					avante = {
						make_slash_commands = true, -- make /slash commands from MCP server prompts
					},
				},
			})
		end,
	},
}

return M
