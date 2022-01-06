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
    local locations = state.get "locations"
    local filenames = vim.tbl_map(function(location)
        return location.filename
    end, locations)
    vim.cmd [[ silent! argdelete * ]]
    vim.cmd(string.format("argadd %s", table.concat(filenames, " ")))
end

M.send_to_quickfix = function(item)
    if not item then
        return
    end
    local locations = state.get "locations"
    vim.fn.setqflist(locations)
end

M.from_state = function(item, idx)
    if not item then
        state.reset()
        return
    end
    local kind = state.get "kind" or "file"
    local default_action = "edit"
    local action_map = {
        edit = M.edit,
        split = M.split,
        vsplit = M.vsplit,
        quickfix = M.send_to_quickfix,
        args = M.send_to_args,
    }
    if kind == "args" then
        default_action = "edit"
        action_map = {
            edit = M.edit_arg,
            split = M.split_arg,
            vsplit = M.vsplit_arg,
            quickfix = M.send_to_quickfix,
            args = M.send_to_args,
        }
    elseif kind == "quickfix" then
        action_map = {
            edit = M.edit_qf,
            split = M.split_qf,
            vsplit = M.vsplit_qf,
            quickfix = M.send_to_quickfix,
            args = M.send_to_args,
        }
    end
    local action = state.get "action" or default_action
    local on_choice_function = action_map[action]
    on_choice_function(item, idx)
    state.reset()
end

return M
