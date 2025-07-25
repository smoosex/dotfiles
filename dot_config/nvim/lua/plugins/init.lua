---@type NvPluginSpec[]
return {
	-- [[ ################################### base ################################### ]]
	-- conform
	{
		"stevearc/conform.nvim",
		require("configs.syntax").conform,
	},

	-- cmp
	{
		"hrsh7th/nvim-cmp",
		require("configs.complete").cmp,
	},

	-- lsp
	{
		"neovim/nvim-lspconfig",
		require("configs.syntax").lspconfig,
	},

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		require("configs.syntax").treesitter,
	},

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		require("configs.telescope").telescope,
	},

	-- gitsigns
	{
		"lewis6991/gitsigns.nvim",
		require("configs.git").gitsigns,
	},

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
	{
		"folke/zen-mode.nvim",
		require("configs.enhancement").zen,
	},

	-- todo comments
	{
		"folke/todo-comments.nvim",
		require("configs.telescope").todo_comments,
	},

	-- pretty diagnostics panel
	{
		"folke/trouble.nvim",
		require("configs.syntax").trouble,
	},

	-- nvim-ts-context-commentstring
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		require("configs.syntax").ts_context_comment,
	},

	-- parinfer
	{
		"gpanders/nvim-parinfer",
		require("configs.syntax").parinfer,
	},

	-- flash
	{
		"folke/flash.nvim",
		require("configs.enhancement").flash,
	},

	-- snack
	{
		"folke/snacks.nvim",
		require("configs.enhancement").snack,
	},

	-- nvim-surround
	{
		"kylechui/nvim-surround",
		require("configs.enhancement").surround,
	},

	-- multicursor
	{
		"jake-stewart/multicursor.nvim",
		require("configs.enhancement").multicursor,
	},

	-- markdown peek
	{
		"toppair/peek.nvim",
		require("configs.markdown").peek,
	},

	-- render-markdown
	{ "MeanderingProgrammer/render-markdown.nvim", require("configs.markdown").render_markdown },

	-- glimmer
	{
		"rachartier/tiny-glimmer.nvim",
		require("configs.enhancement").glimmer,
	},

	-- spectre
	{
		"nvim-pack/nvim-spectre",
		require("configs.enhancement").spectre,
	},

	-- floaterm
	{
		"nvzone/floaterm",
		require("configs.enhancement").floaterm,
	},

  --diffview
  {
    "sindrets/diffview.nvim",
    require("configs.git").diffview,
  },

  -- avante
	-- {
	-- 	"yetone/avante.nvim",
	-- 	require("configs.ai").avante,
	-- },

	-- im-select
	{
		"keaising/im-select.nvim",
		require("configs.enhancement").im_select,
	},

	-- [[ #################################################################################### ]]

	-- [[ ################################### intergration ################################### ]]
	-- yazi
	{
		"mikavilpas/yazi.nvim",
		require("configs.intergration").yazi,
	},

	-- vim-tmux-navigator
	{
		"christoomey/vim-tmux-navigator",
		require("configs.intergration").tmux,
	},

	-- chezmoi
	{
		"xvzc/chezmoi.nvim",
		require("configs.intergration").chezmoi,
	},

	{ "jbyuki/venn.nvim", enabled = false, cmd = "VBox" },
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
