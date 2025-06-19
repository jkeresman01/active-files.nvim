--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: util.lua
-- Author: Josip Keresman

local M = {}

-- Gets the root directory of the current project
--
-- @return The current working directory as a string
function M.get_project_root()
    return vim.fn.getcwd()
end

-- Checks if a file is within the current project directory
--
-- @param filepath The full path to the file
--
-- @return `true` if the file path starts with the project root, otherwise `false`
function M.is_project_file(filepath)
    return filepath:find(M.get_project_root(), 1, true) == 1
end

-- Checks if a file is readable
--
-- @param path The path to the file
--
-- @return `true` if the file is readable, otherwise `false`
function M.is_readable_file(path)
    return vim.fn.filereadable(path) == 1
end

return M
