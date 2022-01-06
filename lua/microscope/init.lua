local config = require "microscope.config"

local M = {}

M.setup = function(opts)
    config.update(opts)
end

return M
