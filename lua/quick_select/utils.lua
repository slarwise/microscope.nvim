local config = require "quick_select.config"

local M = {}

-- location keys
--  filename (mandatory)
--  lnum
--  col

M.make_location = function(filename, lnum, col)
    return {
        filename = vim.fn.fnamemodify(filename, ":~:."),
        lnum = lnum,
        col = col,
    }
end

M.format_location = function(item)
    return item.filename
end

M.format_location_filename_only = function(item)
    return vim.fn.fnamemodify(item.filename, ":t")
end

return M
