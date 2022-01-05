local utils = require "quick_select.utils"

local M = {}

M.args = function()
    local args = vim.fn.argv()
    return vim.tbl_map(utils.make_location, args)
end

M.quickfix = function()
    local items = vim.fn.getqflist()
    local locations = {}
    for _, item in ipairs(items) do
        local filename = vim.api.nvim_buf_get_name(item.bufnr)
        local location = utils.make_location(filename, item.lnum, item.col)
        table.insert(locations, location)
    end
    return locations
end

M.command = function(cmd)
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        return
    end
    return vim.tbl_map(utils.make_location, output)
end

return M
