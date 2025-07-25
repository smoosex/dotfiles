local argv = vim.v.argv
local sep_idx = vim.fn.index(argv, "--theme")
local theme_name = ""
if sep_idx > 0 then
	theme_name = argv[sep_idx + 2]
else
	return
end

print("Switching to theme: " .. theme_name)

local new_theme = '"' .. theme_name .. '"'
local old_theme = '"' .. require("chadrc").base46.theme .. '"'
require("nvchad.utils").replace_word(old_theme, new_theme)

local fn = vim.fn
local uv = vim.loop

-- Acquire and normalize TMPDIR
local tmp = os.getenv("TMPDIR") or "/tmp/"
if not tmp:match("/$") then
	tmp = tmp .. "/"
end

-- Find all files of the form nvim.*/*/nvim.*
local pattern = tmp .. "nvim.*/*/nvim.*"
local socks = fn.glob(pattern, false, true)

-- Determine whether pid is alive (kill(pid, 0))
local function is_alive(pid)
	local ok, err = uv.kill(pid, 0)
	-- ok==true or EPERM (process exists but has no permissions) is considered alive
	return ok or (err and err:match("EPERM"))
end

local reload_cmd = [[
  local theme = ...
  require('nvchad.themes.utils').reload_theme(theme)
]]

for _, sock in ipairs(socks) do
	-- Extract 12345 from "…/nvim.12345.0"
	local pid = tonumber(sock:match("nvim%.(%d+)%."))
	if pid and is_alive(pid) then
		local chan = fn.sockconnect("pipe", sock, { rpc = true })
		if chan > 0 then
			fn.rpcnotify(chan, "nvim_exec_lua", reload_cmd, { theme_name })
			print("Reloaded:", sock)
		else
			vim.notify("Failed to connect to socket: " .. sock, vim.log.levels.ERROR)
		end
	else
		print("Skipping dead socket: " .. sock)
		-- You can also delete the old socket file if necessary：
		uv.fs_unlink(sock)
	end
end
