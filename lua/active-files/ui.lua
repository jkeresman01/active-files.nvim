local M = {}

M.active_files = {}
M.max_files = 10


local function get_project_root()
    return vim.fn.getcwd()
end

local function is_project_file(filepath)
    local project_root = get_project_root()
    return filepath:find(project_root, 1, true) == 1
end

local function create_window()
    local width = 50
    local height = 20
    local borderchars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
    local bufnr = vim.api.nvim_create_buf(false, true)

    local win_id = vim.api.nvim_open_win(bufnr, true, {
        title =  "[ Active files ]",
        relative = "editor",
        title_pos = "center",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = borderchars
    })

    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.api.nvim_win_set_option(win_id, "winhl", "NormalFloat:NormalFloatTransparent,FloatBorder:FloatBorderTransparent")

    return { bufnr = bufnr, win_id = win_id }
end

local function is_present_in_active_files(filepath)
    for i, file in ipairs(M.active_files) do
        if file == filepath then
            return true;
        end
    end

    return false
end

function M.add_file(filepath)

    if not is_project_file(filepath) or is_present_in_active_files(filepath) then
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

function M.switch_to_file(index)
    print(M.active_files[index]);
    local switcth_to_file_cmd = string.format("edit %s",  M.active_files[index].trim());
    vim.cmd(switcth_to_file_cmd)
    M.add_file(M.active_files[index])
end

function M.select_file()
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

    vim.schedule(function()
        M.switch_to_file(row)
        vim.api.nvim_win_close(0, true)
    end)
end

function M.show_active_files()
    local win_info = create_window()
    local bufnr = win_info.bufnr
    local lines = {}

    for i, file in ipairs(M.active_files) do
        table.insert(lines, i .. " " .. vim.fn.fnamemodify(file, ":t"))
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local filepath = vim.fn.expand("%:p")
        if filepath ~= "" then
            M.add_file(filepath)
        end
    end
})

return M
