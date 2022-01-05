# glasses.nvim

When a telescope is overkill.

## Features

Use vim.ui.select to go to a location, or set the quickfix/args list to a set of
locations.

Add a mapping to vim.dressing to be able to choose the nth item. For example,
pressing 3 chooses the 3rd item.

- Goto
  - Args
  - Dotfiles
  - Interesting files (arbitrary files specified by the user in a file)
  - Files in same dir as current file
- Set quickfix/args list
  - A calltree, how the call flows through the code (quickfix)
  - git diff main --name-only (nice to pass to args)

This gives the following API:

```lua
function goto(what) end
function set(to, from) end
```

For example

```lua
function goto(args) vim.ui.select(args, opts, on_choice = edit) end
function set(quickfix, locations) set_quickfix(locations) end
```

What needs to be done

- Items
  - Get args, dotfiles, files in same dir as a list of locations
  - Call a function to create a custom list, or read list from a file, json.
    Probably easiest to set it up in the setup function.
- vim.ui.select(items, {format_item, prompt}, on_choice)
  - format_item, can be the same for all locations, show the filename, and also
    row and col if they are not nil
  - on_choice
    - Go to location
    - Special for arguments, use `:argument {idx}`
- Set functions
  - Set quickfix list from locations
  - Set args from locations
