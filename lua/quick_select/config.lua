local default_config = {}

local M = vim.deepcopy(default_config)

M.update = function(opts)
    local new_config = vim.tbl_deep_extend("force", default_config, opts or {})
    for k, v in pairs(new_config) do
        M[k] = v
    end
end

return M
