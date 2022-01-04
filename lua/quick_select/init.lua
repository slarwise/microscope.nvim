local utils = require "quick_select.utils"
local config = require "quick_select.config"

local M = {}

local default_opts = { format_item = utils.format_item }

M.goto_choose = function()
    local opts = { prompt = "Choose where to go" }
    local choices = {}
    for name, _ in pairs(config.lists) do
        table.insert(choices, name)
    end
    table.insert(choices, "args")
    table.insert(choices, "quickfix")
    local on_choice = function(choice)
        if not choice then
            return
        end
        if choice == "args" then
            M.goto_arg()
        elseif choice == "quickfix" then
            M.goto_quickfix_location()
        else
            M.goto_custom_list_location(choice)
        end
    end
    vim.ui.select(choices, opts, on_choice)
end

M.goto_arg = function()
    local args = utils.get_args()
    if #args == 0 then
        vim.notify "Args list is empty"
        return
    end
    local opts = vim.tbl_extend("error", default_opts, { prompt = "Select argument" })
    vim.ui.select(args, opts, utils.on_choice_arg)
end

M.goto_quickfix_location = function()
    local items = utils.get_quickfix_items()
    if #items == 0 then
        vim.notify "Quickfix list is empty"
        return
    end
    local opts = vim.tbl_extend("error", default_opts, { prompt = "Select quickfix item" })
    vim.ui.select(items, opts, utils.on_choice_file)
end

M.goto_custom_list_location = function(name)
    local locations = utils.get_custom_list(name)
    if not locations then
        vim.notify(string.format("%s is not in the configured list of locations", name))
        return
    end
    local opts = vim.tbl_extend("error", default_opts, { prompt = "Select file" })
    vim.ui.select(locations, opts, utils.on_choice_file)
end

M.goto_custom_command = function(name)
    local command = utils.get_custom_command(name)
    if not command then
        vim.notify(string.format("%s is not in the configured list of commands", name))
        return
    end
    local locations = utils.execute_command(command.cmd)
    if not locations then
        vim.notify(string.format("No stdout, either empty or error", command.cmd))
        return
    end
    local opts = vim.tbl_extend("error", default_opts, { prompt = "Select file" })
    vim.ui.select(locations, opts, utils.on_choice_file)
end

M.send_to_choose = function()
    local opts = { prompt = "Choose where to send locations" }
    local choices = { "args", "quickfix" }
    local on_choice = function(choice)
        if not choice then
            return
        end
        if choice == "args" then
            M.send_to_args()
        elseif choice == "quickfix" then
            M.send_to_quickfix()
        end
    end
    vim.ui.select(choices, opts, on_choice)
end

M.send_to_quickfix = function()
    local opts = { prompt = "Send to quickfix" }
    local choices = {}
    for name, _ in pairs(config.lists) do
        table.insert(choices, name)
    end
    table.insert(choices, "args")
    local on_choice = function(choice)
        if not choice then
            return
        end
        if choice == "args" then
            local args = utils.get_args()
            utils.set_quickfix(args)
        else
            local locations = config.lists[choice]
            utils.set_quickfix(locations)
        end
    end
    vim.ui.select(choices, opts, on_choice)
end

M.send_to_args = function()
    local opts = { prompt = "Send to argument list" }
    local choices = {}
    for name, _ in pairs(config.lists) do
        table.insert(choices, name)
    end
    table.insert(choices, "quickfix")
    local on_choice = function(choice)
        if not choice then
            return
        end
        if choice == "quickfix" then
            local locations = utils.get_quickfix_items()
            utils.set_args(locations)
        else
            local locations = config.lists[choice]
            utils.set_args(locations)
        end
    end
    vim.ui.select(choices, opts, on_choice)
end

M.setup = function(opts)
    config.update(opts)
end

-- M.select_quickfix()

return M
