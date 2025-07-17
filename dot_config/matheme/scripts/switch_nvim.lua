local argv = vim.v.argv
local sep_idx = vim.fn.index(argv, "--theme")
local theme_name = ""
if sep_idx > 0 then
	theme_name = argv[sep_idx + 2]
else
	return
end

print(theme_name)

require("nvconfig").base46.theme = theme_name

-- reload_all.lua
local fn = vim.fn
local uv = vim.loop

-- 获取并规范化 TMPDIR
local tmp = os.getenv("TMPDIR") or "/tmp/"
if not tmp:match("/$") then
	tmp = tmp .. "/"
end

-- 找到所有形如 nvim.*/*/nvim.* 的文件
local pattern = tmp .. "nvim.*/*/nvim.*"
local socks = fn.glob(pattern, false, true)

-- 判断 pid 是否存活（kill(pid, 0)）
local function is_alive(pid)
	local ok, err = uv.kill(pid, 0)
	-- ok==true 或者返回的是 EPERM（进程存在但无权限）都算活着
	return ok or (err and err:match("EPERM"))
end

local reload_cmd = [[
  local theme = ...
  require('nvchad.themes.utils').reload_theme(theme)
]]

for _, sock in ipairs(socks) do
	-- 从 “…/nvim.12345.0” 提取出 12345
	local pid = tonumber(sock:match("nvim%.(%d+)%."))
	if pid and is_alive(pid) then
		local chan = fn.sockconnect("pipe", sock, { rpc = true })
		if chan > 0 then
			fn.rpcnotify(chan, "nvim_exec_lua", reload_cmd, { theme_name })
			print("Reloaded:", sock)
		else
			vim.notify("连接失败（RPC 通道打开失败）: " .. sock, vim.log.levels.WARN)
		end
	else
		print("跳过无效或已退出的 socket:", sock)
		-- 如果需要也可以删除旧的 socket 文件：
		-- uv.fs_unlink(sock)
	end
end
