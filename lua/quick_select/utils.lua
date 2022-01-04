local config = require "quick_select.config"

local M = {}

-- location keys
--  filename (mandatory)
--  lnum
--  col

local make_location = function(filename, lnum, col)
    return {
        filename = filename,
        lnum = lnum,
        col = col,
    }
end

M.get_quickfix_items = function()
    local items = vim.fn.getqflist()
    local valid_items = vim.tbl_filter(function(item)
        return item.valid == 1
    end, items)

    local locations = {}
    for _, item in ipairs(items) do
        local filename = vim.api.nvim_buf_get_name(item.bufnr)
        local location = make_location(filename, item.lnum, item.col)
        table.insert(locations, location)
    end
    return locations
end

M.set_quickfix = function(locations)
    vim.fn.setqflist(locations)
end

M.get_args = function()
    local args = vim.fn.argv()
    return vim.tbl_map(make_location, args)
end

M.set_args = function(locations)
    local filenames = vim.tbl_map(function(location)
        return location.filename
    end, locations)
    vim.cmd [[ silent! argdelete * ]]
    vim.cmd(string.format("argadd %s", table.concat(filenames, " ")))
end

M.get_custom_list = function(name)
    for k, v in pairs(config.lists) do
        if k == name then
            return v
        end
    end
end

M.get_all_custom_lists = function()
    return config.lists
end

M.get_custom_command = function(name)
    for k, v in pairs(config.commands) do
        if name == k then
            return v
        end
    end
end

M.execute_command = function(cmd)
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        return
    end
    local locations = {}
    for _, filename in ipairs(output) do
        local location = make_location(filename)
        table.insert(locations, location)
    end
    return locations
end

M.on_choice_file = function(item)
    if not item then
        return
    end
    if item.lnum and item.col then
        pcall(vim.cmd, string.format("edit +call\\ cursor(%d,%d) %s", item.lnum, item.col, item.filename))
    else
        pcall(vim.cmd, "edit " .. item.filename)
    end
end

M.on_choice_arg = function(item, idx)
    if not item then
        return
    end
    pcall(vim.cmd(string.format("argument %d", idx)))
end

M.format_item = function(item)
    return item.filename
end

return M
