local M = {}

local split = function(str, sep)
	local t = {}
	local pattern = string.format("([^%s]+)", sep)
	for part in string.gmatch(str, pattern) do
		table.insert(t, part)
	end
	return t
end

M.get_windows = function(session)
  if session == nil then
    return nil
  end
	local window = io.popen(
		"tmux list-windows -t "
			.. session
			.. ' -F "#{window_index}:#{window_name}:#{window_active}:#{pane_current_path}"'
	)
	local windows = {}
	if window ~= nil then
		for line in window:lines() do
			local wc = split(line, ":")
			windows[wc[1]] = {
				index = wc[1],
				name = wc[2],
				active = wc[3],
				path = wc[4],
			}
		end
    return windows
	else
		return nil
	end
end

M.get_sessions = function()
	local session = io.popen(
		'tmux list-sessions -F "#{session_name}:#{session_windows}:#{session_attached}:#{active_window_index}"'
	)
	local sessions = {}
	if session ~= nil then
		for line in session:lines() do
			local sc = split(line, ":")
			table.insert(sessions, {
				name = sc[1],
				windows = sc[2],
				attached = sc[3],
				active_window = sc[4],
			})
		end
		return sessions
	else
		return nil
	end
end

return M
