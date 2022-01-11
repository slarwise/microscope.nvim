local utils = require "microscope.utils"

local M = {}

M.args = function()
    local args = vim.fn.argv()
    return vim.tbl_map(utils.make_item, args)
end

M.quickfix = function()
    local quickfix_items = vim.fn.getqflist()
    local items = {}
    for _, qf_item in ipairs(quickfix_items) do
        local filename = vim.api.nvim_buf_get_name(qf_item.bufnr)
        local item = utils.make_item(filename, qf_item.lnum, qf_item.col)
        table.insert(items, item)
    end
    return items
end

M.command = function(cmd)
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        return
    end
    return vim.tbl_map(utils.make_item, output)
end

return M
