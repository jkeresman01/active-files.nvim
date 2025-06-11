--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: ui.lua
-- Author: Josip Keresman

local util = require("active-files.util")

local M = {}

M.active_files = {}
M.max_files = 9
M.win_id = nil
M.bufnr = nil
M.index_lookup = {}

function M.track_file(filepath)
    if not util.is_project_file(filepath) then
        return
    end
    for i, file in ipairs(M.active_files) do
        if file == filepath then
            table.remove(M.active_files, i)
            break
        end
    end
    table.insert(M.active_files, 1, filepath)
    if #M.active_files > M.max_files then
        table.remove(M.active_files)
    end
end

local function close_window()
    if M.win_id and vim.api.nvim_win_is_valid(M.win_id) then
        vim.api.nvim_win_close(M.win_id, true)
    end
end

local function focus_previous_window()
    local prev_win = vim.fn.win_getid(vim.fn.winnr("#"))
    if prev_win and vim.api.nvim_win_is_valid(prev_win) then
        vim.api.nvim_set_current_win(prev_win)
    end
end

function M.switch_to_file(index)
    if not index or index < 1 or index > #M.active_files then
        print("Invalid file index: " .. tostring(index))
        return
    end

    local file = M.active_files[index]
    if not util.is_readable_file(file) then
        print("File not readable: " .. tostring(file))
        return
    end

    vim.schedule(function()
        if vim.fn.expand("%:p") == file then
            close_window()
            return
        end
        focus_previous_window()
        vim.cmd("edit " .. vim.fn.fnameescape(file))
        M.track_file(file)
    end)
end

function M.select_file()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local index = M.index_lookup[row]
    if not index then
        return
    end
    vim.schedule(function()
        M.switch_to_file(index)
        close_window()
    end)
end

local function create_window()
    local width, height = 50, 10
    local borderchars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

    M.bufnr = vim.api.nvim_create_buf(false, true)
    M.win_id = vim.api.nvim_open_win(M.bufnr, true, {
        title = "[ Active Files ]",
        relative = "editor",
        title_pos = "center",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = borderchars,
    })

    vim.api.nvim_buf_set_option(M.bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(M.bufnr, "modifiable", true)
    vim.api.nvim_win_set_option(
        M.win_id,
        "winhl",
        "NormalFloat:NormalFloatTransparent,FloatBorder:FloatBorderTransparent"
    )

    return M.bufnr
end

function M.show_active_files()
    local bufnr = create_window()
    local cwd = util.get_project_root()
    local lines = {}
    M.index_lookup = {}

    for i, file in ipairs(M.active_files) do
        local rel_path = file:sub(#cwd + 2)
        table.insert(lines, string.format("   %s", rel_path))
        M.index_lookup[#lines] = i
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

    local ns_id = vim.api.nvim_create_namespace("active_files_ns")
    for i = 1, #lines do
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, {
            virt_text = { { tostring(i), "Comment" } },
            virt_text_win_col = 0,
            hl_mode = "combine",
        })
    end
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local filepath = vim.fn.expand("%:p")
        if filepath and filepath ~= "" then
            M.track_file(filepath)
        end
    end,
})

return M
