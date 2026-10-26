local M = {}

function M.glass()
	if vim.g.neovide then
		return false
	end
	local file = io.open(vim.env.HOME .. "/.local/state/matheme/material", "r")
	if not file then
		return false
	end
	local mode = file:read("*l")
	file:close()
	return mode == "glass"
end

function M.sync()
	if vim.g.neovide then
		return
	end
	local config = require("nvconfig")
	local glass = M.glass()
	if M.applied == glass then
		return
	end
	config.base46.transparency = glass
	require("base46").load_all_highlights()
	M.applied = glass
end

function M.setup()
	if vim.g.neovide then
		return
	end
	M.sync()
	-- Terminal multiplexers do not always forward focus events.
	M.timer = vim.uv.new_timer()
	M.timer:start(1000, 1000, vim.schedule_wrap(M.sync))
	vim.api.nvim_create_autocmd("VimLeavePre", {
		once = true,
		callback = function()
			M.timer:stop()
			M.timer:close()
		end,
	})
end

return M
