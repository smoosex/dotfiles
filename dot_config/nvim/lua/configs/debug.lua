local M = {
    dependencies = {
        -- "rcarriga/nvim-dap-ui",
        -- "nvim-neotest/nvim-nio",
        -- "folke/neodev.nvim",
        -- "theHamsta/nvim-dap-virtual-text",
        "leoluz/nvim-dap-go",
    },
    config = function()
        dofile(vim.g.base46_cache .. "dap")
        -- require("nvim-dap-virtual-text").setup()

        -- Custom breakpoint icons
        vim.fn.sign_define(
            "DapBreakpoint",
            { text = "🧘", texthl = "DapBreakpoint", linehl = "", numhl = "DapBreakpoint" }
        )
        vim.fn.sign_define("DapBreakpointCondition", {
            text = "🧘",
            texthl = "DapBreakpointCondition",
            linehl = "DapBreakpointCondition",
            numhl = "DapBreakpointCondition",
        })
        vim.fn.sign_define(
            "DapStopped",
            { text = "🏃", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
        )

        local dap = require "dap"
        dap.adapters.delve = function(callback, config)
            if config.mode == "remote" and config.request == "attach" then
                callback {
                    type = "server",
                    host = config.host or "127.0.0.1",
                    port = config.port or "38697",
                }
            else
                callback {
                    type = "server",
                    port = "${port}",
                    executable = {
                        command = "dlv",
                        args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
                        detached = vim.fn.has "win32" == 0,
                    },
                }
            end
        end
    end,

    keys = {
        -- stylua: ignore start
        { "<leader>dJ", function() require("dap").continue() end, desc = "Dap Continue", },
        { "<leader>dr", function() require("dap").restart() end, desc = "Dap Restart the Current Session", },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Dap Terminates the Debug Session", },
        { "<leader>dj", function() require("dap").step_over() end, desc = "Dap Step Over", },
        { "<leader>di", function() require("dap").step_into() end, desc = "Dap Step In", },
        { "<leader>do", function() require("dap").step_out() end, desc = "Dap Step Out", },
        { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Dap Toggle BreakPoint", },
        { "<Leader>dB", function() require("dap").set_breakpoint() end, desc = "Dap Set BreakPoint", },
        { "<Leader>dl", function() require("dap").list_breakpoints(true) end, desc = "Dap Lists All Breakpoints", },
        { "<Leader>dc", function() require("dap").clear_breakpoints() end, desc = "Dap Removes All Breakpoints", },
        { "<Leader>dP", function() require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ") end, desc = "Dap Set Log Point", },
        { "<Leader>dn", function() require("dap").repl.toggle() end, desc = "Dap Toggle Repl", },
        { "<Leader>df", function()
                local widgets = require "dap.ui.widgets"
                local view = widgets.centered_float(widgets.frames)
                local bufnr = vim.api.nvim_get_current_buf()
                vim.keymap.set("n", "q", function()
                    view.close()
                end, { buffer = bufnr, noremap = true, silent = true })
            end,
            desc = "Dap Center Float Frame",
        },
        {
            "<Leader>da",
            function()
                local widgets = require "dap.ui.widgets"
                local view = widgets.centered_float(widgets.scopes)
                local bufnr = vim.api.nvim_get_current_buf()
                vim.keymap.set("n", "q", function()
                    view.close()
                end, { buffer = bufnr, noremap = true, silent = true })
            end,
            desc = "Dap Center Float Scope",
        },
        -- stylua: ignore end
    },
}

return M
