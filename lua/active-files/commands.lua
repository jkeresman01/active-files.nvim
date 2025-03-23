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

function M.register()
    vim.api.nvim_create_user_command("ShowActiveFiles", function()
        ui.show_active_files()
    end, {
        desc = "Show active files",
    })

    vim.api.nvim_create_user_command("SelectActiveFile", function()
        ui.select_file()
    end, {
        desc = "Select active file",
    })
end

return M
