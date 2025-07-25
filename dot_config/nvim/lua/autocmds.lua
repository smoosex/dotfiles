require "nvchad.autocmds"

-- autosave BEGIN
local create_cmd = vim.api.nvim_create_user_command

local function clear_cmdarea()
	vim.defer_fn(function()
		vim.api.nvim_echo({}, false, {})
	end, 800)
end

local echo = function(txts)
	vim.api.nvim_echo(txts, false, {})
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	nested = true,
	callback = function()
		if vim.g.autosave and #vim.api.nvim_buf_get_name(0) ~= 0 and vim.bo.buflisted then
			vim.cmd("silent w")

			echo({ { "󰄳", "LazyProgressDone" }, { " file autosaved at " .. os.date("%I:%M %p") } })

			clear_cmdarea()
		end
	end,
})

create_cmd("AsToggle", function()
	vim.g.autosave = not vim.g.autosave

	local enabledTxt = { { "󰆓 ", "LazyProgressDone" }, { "autosave enabled!" } }
	local disabledTxt = { { "  ", "LazyNoCond" }, { "autosave disabled" } }

	echo(vim.g.autosave and enabledTxt or disabledTxt)

	clear_cmdarea()
end, {})
-- autosave END

-- show Nvdash when last buffer is deleted
vim.api.nvim_create_autocmd("BufDelete", {
	callback = function()
		local bufs = vim.t.bufs
		if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
			vim.cmd("Nvdash")
		end
	end,
})

-- Restore cursor position
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local line = vim.fn.line("'\"")
		if
			line > 1
			and line <= vim.fn.line("$")
			and vim.bo.filetype ~= "commit"
			and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
		then
			vim.cmd('normal! g`"')
		end
	end,
})

-- Ts Context Comment
local orig_get_option = vim.filetype.get_option
rawset(vim.filetype, "get_option", function(filetype, option)
	if option == "commentstring" then
		return require("ts_context_commentstring.internal").calculate_commentstring()
	else
		return orig_get_option(filetype, option)
	end
end)

-- format files on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go", "*.py" },
	callback = function(args)
		require("conform").format({ bufnr = args.buf, timeout_ms = 5000, lsp_fallback = false })
	end,
})

-- set indentation for different filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "python" },
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
	end,
})

-- prevent buffers from opening in the terminal window
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.opt_local.buflisted = false
	end,
})

-- auto chezmoi apply
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
	callback = function(ev)
		local bufnr = ev.buf
		local edit_watch = function()
			require("chezmoi.commands.__edit").watch(bufnr)
		end
		vim.schedule(edit_watch)
	end,
})
