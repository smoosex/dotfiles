return {
	-- [[ ################################### base ################################### ]]
	-- conform
	require("configs.syntax").conform,
	-- cmp
	require("configs.complete").cmp,
	-- lsp
	require("configs.syntax").lspconfig,
	-- treesitter
	require("configs.syntax").treesitter,
	-- telescope
	require("configs.telescope").telescope,
	-- gitsigns
	require("configs.git").gitsigns,
	-- timerly
	{
		"nvzone/timerly",
		cmd = "TimerlyToggle",
	},

	-- showkeys
	{
		"nvzone/showkeys",
		cmd = "ShowkeysToggle",
	},

	-- typr
	{
		"nvzone/typr",
		cmd = "TyprStats",
		dependencies = "nvzone/volt",
		opts = {},
	},

	-- [[ ################################### enhancement ################################### ]]

	-- zen mode
	require("configs.enhancement").zen,
	-- todo comments
	require("configs.telescope").todo_comments,
	-- pretty diagnostics panel
	require("configs.syntax").trouble,
	-- nvim-ts-context-commentstring
	require("configs.syntax").ts_context_comment,
	-- parinfer
	require("configs.syntax").parinfer,
	-- flash
	require("configs.enhancement").flash,
	-- snack
	require("configs.enhancement").snack,
	-- nvim-surround
	require("configs.enhancement").surround,
	-- multicursor
	require("configs.enhancement").multicursor,
	-- markdown peek
	require("configs.markdown").peek,
	-- render-markdown
	require("configs.markdown").render_markdown,
	-- glimmer
	require("configs.enhancement").glimmer,
	-- spectre
	-- require("configs.enhancement").spectre,
	-- floaterm
	require("configs.enhancement").floaterm,
	--diffview
	require("configs.git").diffview,
	-- avante
	require("configs.ai").avante,
	-- im-select
	require("configs.enhancement").im_select,
	-- hardtime
	require("configs.enhancement").hahrdtime,

	-- [[ #################################################################################### ]]

	-- [[ ################################### intergration ################################### ]]
	-- yazi
	require("configs.intergration").yazi,
	-- vim-tmux-navigator
	require("configs.intergration").tmux,
	-- chezmoi
	require("configs.intergration").chezmoi,
	-- { "jbyuki/venn.nvim", enabled = false, cmd = "VBox" },

	-- [[ #################################################################################### ]]

	-- dap
	{
		"mfussenegger/nvim-dap",
		dependencies = require("configs.debug").dependencies,
		config = require("configs.debug").config,
		keys = require("configs.debug").keys,
	},

	-- dap-go
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup()
		end,
	},
}
