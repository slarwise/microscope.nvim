local M = {}

State = State or {}

M.set = function(key, val)
    State[key] = val
end

M.get = function(key)
    return State[key]
end

M.reset = function()
    State = {}
end

return M
