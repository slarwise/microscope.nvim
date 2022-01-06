local utils = require "quick_select.utils"
local locations = require "quick_select.locations"
local state = require "quick_select.state"
local on_choice = require "quick_select.on_choice"

local M = {}

M.args = function()
    local args = locations.args()
    if #args == 0 then
        vim.notify "Args list is empty"
        return
    end
    state.set("locations", args)
    state.set("kind", "arg")
    local opts = { format_item = utils.format_location, prompt = "Args" }
    vim.ui.select(args, opts, on_choice.from_state)
end

M.quickfix = function()
    local quickfix_items = locations.quickfix()
    if #quickfix_items == 0 then
        vim.notify "Quickfix list is empty"
        return
    end
    state.set("locations", quickfix_items)
    state.set("kind", "quickfix")
    local opts = { format_item = utils.format_location, prompt = "Quickfix" }
    vim.ui.select(quickfix_items, opts, on_choice.from_state)
end

M.cwd = function()
    local files = locations.command "ls"
    if #files == 0 then
        vim.notify "No files in current working directory"
        return
    end
    state.set("locations", files)
    local opts = { format_item = utils.format_location_filename_only, prompt = "Current working directory" }
    vim.ui.select(files, opts, on_choice.from_state)
end

M.buffer_dir = function()
    local buffer_name = vim.api.nvim_buf_get_name(0)
    local buffer_dir = vim.fn.fnamemodify(buffer_name, ":h")
    local files = locations.command(string.format("ls %s/*", buffer_dir))
    if #files == 0 then
        vim.notify(string.format("No files in %s", buffer_dir))
        return
    end
    state.set("locations", files)
    local opts = {
        format_item = utils.format_location_filename_only,
        prompt = string.format("%s/", vim.fn.fnamemodify(buffer_dir, ":~:.")),
    }
    vim.ui.select(files, opts, on_choice.from_state)
end

return M
