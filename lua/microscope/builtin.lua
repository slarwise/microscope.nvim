local utils = require "microscope.utils"
local locations = require "microscope.locations"
local state = require "microscope.state"
local on_choice = require "microscope.on_choice"

local M = {}

M.args = function()
    local args = locations.args()
    if #args == 0 then
        vim.notify "Args list is empty"
        return
    end
    state.set("locations", args)

    local available_on_choice = {
        edit = on_choice.edit_arg,
        split = on_choice.split_arg,
        vsplit = on_choice.vsplit_arg,
        quickfix = on_choice.send_to_quickfix,
        args = on_choice.send_to_args,
    }
    state.set("available_on_choice", available_on_choice)
    state.set("on_choice", "edit")

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

    local available_on_choice = {
        edit = on_choice.edit_quickfix,
        split = on_choice.split_quickfix,
        vsplit = on_choice.vsplit_quickfix,
        quickfix = on_choice.send_to_quickfix,
        args = on_choice.send_to_args,
    }
    state.set("available_on_choice", available_on_choice)
    state.set("on_choice", "edit")

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

    local available_on_choice = {
        edit = on_choice.edit,
        split = on_choice.split,
        vsplit = on_choice.vsplit,
        quickfix = on_choice.send_to_quickfix,
        args = on_choice.send_to_args,
    }
    state.set("available_on_choice", available_on_choice)
    state.set("on_choice", "edit")

    local opts = { format_item = utils.format_location_filename_only, prompt = "Current working directory" }
    vim.ui.select(files, opts, on_choice.from_state)
end

M.buffer_dir = function()
    local buffer_name = vim.api.nvim_buf_get_name(0)
    if buffer_name == "" then
        vim.notify "No buffer open"
        return
    end
    local buffer_dir = vim.fn.fnamemodify(buffer_name, ":h")
    local files = locations.command(string.format("ls -d %s/*", buffer_dir))
    if #files == 0 then
        vim.notify(string.format("No files in %s", buffer_dir))
        return
    end
    state.set("locations", files)

    local available_on_choice = {
        edit = on_choice.edit,
        split = on_choice.split,
        vsplit = on_choice.vsplit,
        quickfix = on_choice.send_to_quickfix,
        args = on_choice.send_to_args,
    }
    state.set("available_on_choice", available_on_choice)
    state.set("on_choice", "edit")

    local opts = {
        format_item = utils.format_location_filename_only,
        prompt = string.format("%s/", vim.fn.fnamemodify(buffer_dir, ":~:.")),
    }
    vim.ui.select(files, opts, on_choice.from_state)
end

M.pickers = function()
    local picker_names = { "args", "quickfix", "cwd", "buffer_dir" }
    local name_to_picker = {
        args = M.args,
        quickfix = M.quickfix,
        cwd = M.cwd,
        buffer_dir = M.buffer_dir,
    }
    local on_choice_picker = function(item)
        local picker = name_to_picker[item]
        picker()
    end
    local opts = { prompt = "Pickers" }
    vim.ui.select(picker_names, opts, on_choice_picker)
end

return M
