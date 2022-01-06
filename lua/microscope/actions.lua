-- These functions should be mappable by the user
-- E.g. set_state_and_select("edit_cmd", "split")
local state = require "microscope.state"

local M = {}

M.set_args = function(locations)
    local filenames = vim.tbl_map(function(location)
        return location.filename
    end, locations)
    vim.cmd [[ silent! argdelete * ]]
    vim.cmd(string.format("argadd %s", table.concat(filenames, " ")))
end

M.set_state_and_select = function(key, val)
    state.set(key, val)
    vim.api.nvim_input [[<CR>]]
end

return M
