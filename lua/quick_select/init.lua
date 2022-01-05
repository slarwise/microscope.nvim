local config = require "quick_select.config"

local M = {}

M.setup = function(opts)
    config.update(opts)
end

return M
