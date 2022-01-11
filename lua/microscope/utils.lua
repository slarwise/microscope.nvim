local M = {}

-- item keys
--  filename (mandatory)
--  lnum
--  col

M.make_item = function(filename, lnum, col)
    return {
        filename = filename,
        lnum = lnum,
        col = col,
    }
end

M.format_item = function(item)
    return item.filename
end

M.format_item_filename_only = function(item)
    return vim.fn.fnamemodify(item.filename, ":t")
end

return M
