local M = {
	avante = {
		"yetone/avante.nvim",
		keys = {
			{ "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Ask a question using Avante" },
		},
		version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
		-- cmd = { "AvanteAsk" },
		opts = {
			-- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
			-- system_prompt = function()
			--     local hub = require("mcphub").get_hub_instance()
			--     return hub:get_active_servers_prompt()
			-- end,
			-- -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
			-- custom_tools = function()
			--     return {
			--         require("mcphub.extensions.avante").mcp_tool(),
			--     }
			-- end,
			provider = "deepseek",
			-- auto_suggestions_provider = "", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
			-- cursor_applying_provider = "claude 3.7 sonnet", -- In this example, use Groq for applying, but you can also use any provider you want.
			behaviour = {
				enable_cursor_planning_mode = false, -- enable cursor planning mode!
				-- enable_claude_text_editor_tool_mode = true, -- only support claude official api
			},
			providers = {
				deepseek = {
					__inherited_from = "openai",
					api_key_name = "DEEPSEEK_API_KEY",
					endpoint = "https://api.deepseek.com",
					model = "deepseek-coder",
				},
			},
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
			-- "ravitemer/mcphub.nvim",
		},

		config = function(_, opts)
			dofile(vim.g.base46_cache .. "avante")
			require("avante").setup(opts)
		end,

		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = vim.fn.has("win32") and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
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
		-- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
		build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
		config = function()
			require("mcphub").setup({
				-- Required options
				port = 3000, -- Port for MCP Hub server
				config = vim.fn.expand("~/mcpservers.json"), -- Absolute path to config file

				-- Optional options
				-- on_ready = function(hub)
				--     -- Called when hub is ready
				-- end,
				-- on_error = function(err)
				--     -- Called on errors
				-- end,
				shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
				log = {
					level = vim.log.levels.WARN,
					to_file = false,
					file_path = nil,
					prefix = "MCPHub",
				},
			})
		end,
	},
}

return M
