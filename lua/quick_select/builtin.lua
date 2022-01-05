local utils = require "quick_select.utils"
local locations = require "quick_select.locations"
local actions = require "quick_select.actions"

local M = {}

M.args = function()
    local args = locations.args()
    if #args == 0 then
        vim.notify "Args list is empty"
        return
    end
    local opts = { format_item = utils.format_location, prompt = "Args" }
    vim.ui.select(args, opts, actions.edit_arg)
end

M.quickfix = function()
    local quickfix_items = locations.quickfix()
    if #quickfix_items == 0 then
        vim.notify "Quickfix list is empty"
        return
    end
    local opts = { format_item = utils.format_location, prompt = "Quickfix" }
    vim.ui.select(quickfix_items, opts, actions.edit_quickfix)
end

M.cwd = function()
    local files = locations.command "ls"
    if #files == 0 then
        vim.notify "No files in current working directory"
        return
    end
    local opts = { format_item = utils.format_location_filename_only, prompt = "Current working directory" }
    vim.ui.select(files, opts, actions.edit)
end

M.buffer_dir = function()
    local buffer_name = vim.api.nvim_buf_get_name(0)
    local buffer_dir = vim.fn.fnamemodify(buffer_name, ":h")
    print(vim.inspect(buffer_dir))
    local files = locations.command(string.format("ls %s/*", buffer_dir))
    if #files == 0 then
        vim.notify(string.format("No files in %s", buffer_dir))
        return
    end
    local opts = {
        format_item = utils.format_location_filename_only,
        prompt = string.format("%s/", vim.fn.fnamemodify(buffer_dir, ":~:.")),
    }
    vim.ui.select(files, opts, actions.edit)
end

return M
