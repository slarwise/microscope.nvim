-- These functions should be mappable by the user
-- E.g. set_state_and_select("edit_cmd", "split")
local state = require "microscope.state"

local M = {}

M.set_action_and_select = function(action)
    state.set("action", action)
    vim.api.nvim_input [[<CR>]]
end

return M
