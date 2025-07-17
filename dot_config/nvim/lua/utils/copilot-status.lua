local M = {}

-- From TJDevries
-- https://github.com/tjdevries/lazy-require.nvim
local function lazy_require(require_path)
    return setmetatable({}, {
        __index = function(_, key)
            return require(require_path)[key]
        end,

        __newindex = function(_, key, value)
            require(require_path)[key] = value
        end,
    })
end

local c = lazy_require "copilot.client"
local a = lazy_require "copilot.api"

local is_current_buffer_attached = function()
    return c.buf_is_attached(vim.api.nvim_get_current_buf())
end

---Check if copilot is enabled
---@return boolean
M.is_enabled = function()
    if c.is_disabled() then
        return false
    end

    if not is_current_buffer_attached() then
        return false
    end

    return true
end

---Check if copilot is online
---@return boolean
M.is_error = function()
    if c.is_disabled() then
        return false
    end

    if not is_current_buffer_attached() then
        return false
    end

    local data = a.status.data.status
    if data == "Warning" then
        return true
    end

    return false
end

---Show copilot running status
---@return boolean
M.is_loading = function()
    if c.is_disabled() then
        return false
    end

    if not is_current_buffer_attached() then
        return false
    end

    local data = a.status.data.status
    if data == "InProgress" then
        return true
    end

    return false
end

---Check auto trigger suggestions
---@return boolean
M.is_sleep = function()
    if c.is_disabled() then
        return false
    end

    if not is_current_buffer_attached() then
        return false
    end

    if vim.b.copilot_suggestion_auto_trigger == nil then
        return lazy_require("copilot.config").get("suggestion").auto_trigger
    end
    return vim.b.copilot_suggestion_auto_trigger
end

M.get_status = function()
    local attached = false
    local client = vim.lsp.get_client_by_id(1)
    if client and client.name == "copilot" then
        attached = true
    end
    local copilot_loaded = package.loaded["copilot"] ~= nil

    if not copilot_loaded or not attached then
        return "unknown"
    end

    if M.is_loading() then
        return "spinner"
    elseif M.is_error() then
        return "warning"
    elseif not M.is_enabled() then
        return "disabled"
    elseif M.is_enabled() then
        return "enabled"
    elseif M.is_sleep() then
        return "sleep"
    else
        return "enabled"
    end
end

return M
