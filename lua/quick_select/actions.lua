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

M.edit_arg = function(item, idx)
    if not item then
        return
    end
    pcall(vim.cmd(string.format("argument %d", idx)))
end

M.edit_quickfix = function(item, idx)
    if not item then
        return
    end
    pcall(vim.cmd(string.format("cc %d", idx)))
end

M.set_args = function(locations)
    local filenames = vim.tbl_map(function(location)
        return location.filename
    end, locations)
    vim.cmd [[ silent! argdelete * ]]
    vim.cmd(string.format("argadd %s", table.concat(filenames, " ")))
end

M.set_quickfix = function(locations)
    vim.fn.setqflist(locations)
end

return M
