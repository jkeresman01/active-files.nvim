--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: commands.lua
-- Author: Josip Keresman

local ui = require("active-files.ui")

local M = {}

-- Registers custom Neovim user commands for interacting with active files
--
-- Commands:
--   :ShowActiveFiles
--   :SelectActiveFile
--   :SwitchToActiveFile {n}
function M.register()
    vim.api.nvim_create_user_command("ShowActiveFiles", function()
        ui.show_active_files()
    end, {
        desc = "Show active files",
    })

    vim.api.nvim_create_user_command("SelectActiveFile", function()
        ui.select_file()
    end, {
        desc = "Select file from active file",
    })

    vim.api.nvim_create_user_command("SwitchToActiveFile", function(opts)
        local index = tonumber(opts.args)
        ui.switch_to_file(index)
    end, {
        desc = "Switch to active file by index",
        nargs = 1,
        complete = function()
            return { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
        end,
    })
end

return M
