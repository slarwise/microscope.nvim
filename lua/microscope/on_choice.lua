local state = require "microscope.state"

local M = {}

M.edit = function(item)
    if not item then
        return
    end
    if item.lnum and item.col then
        pcall(vim.cmd, string.format("edit +call\\ cursor(%d,%d) %s", item.lnum, item.col, item.filename))
    else
        pcall(vim.cmd, "edit " .. item.filename)
    end
end

M.split = function(item)
    if not item then
        return
    end
    if item.lnum and item.col then
        pcall(vim.cmd, string.format("split +call\\ cursor(%d,%d) %s", item.lnum, item.col, item.filename))
    else
        pcall(vim.cmd, "split " .. item.filename)
    end
end

M.vsplit = function(item)
    if not item then
        return
    end
    if item.lnum and item.col then
        pcall(vim.cmd, string.format("vsplit +call\\ cursor(%d,%d) %s", item.lnum, item.col, item.filename))
    else
        pcall(vim.cmd, "vsplit " .. item.filename)
    end
end

M.edit_arg = function(item, idx)
    if not item then
        return
    end
    pcall(vim.cmd(string.format("argument %d", idx)))
end

M.split_arg = function(item, idx)
    if not item then
        return
    end
    pcall(vim.cmd(string.format("sargument %d", idx)))
end

M.vsplit_arg = function(item, idx)
    if not item then
        return
    end
    pcall(vim.cmd(string.format("vertical sargument %d", idx)))
end

M.edit_quickfix = function(item, idx)
    if not item then
        return
    end
    pcall(vim.cmd(string.format("cc %d", idx)))
end

M.split_quickfix = function(item, idx)
    if not item then
        return
    end
    pcall(vim.cmd(string.format("split +cc\\ %d", idx)))
end

M.vsplit_quickfix = function(item, idx)
    if not item then
        return
    end
    pcall(vim.cmd(string.format("vsplit +cc\\ %d", idx)))
end

M.send_to_args = function(item)
    if not item then
        return
    end
    local items = state.get "items"
    local filenames = vim.tbl_map(function(item)
        return item.filename
    end, items)
    vim.cmd [[ silent! argdelete * ]]
    vim.cmd(string.format("argadd %s", table.concat(filenames, " ")))
end

M.send_to_quickfix = function(item)
    if not item then
        return
    end
    local items = state.get "items"
    vim.fn.setqflist(items)
end

M.from_state = function(item, idx)
    if not item then
        state.reset()
        return
    end
    local action = state.get("action")
    local action_map = state.get("action_map")
    local on_choice = action_map[action]
    on_choice(item, idx)
    state.reset()
end

return M
