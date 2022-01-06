# microscope.nvim

When the telescope is overkill :) Send file lists to vim.ui.select and map
actions to perform on these lists. Only file list creation and actions are
provided, use the UI you want by letting it override vim.ui.select.

## Usage

- Builtin lists
  - Args
  - Quickfix
  - Files in the current working directory
  - Files in the directory of the current buffer

Send these to vim.ui.select by doing

```lua
require "microscope.builtin".args()
require "microscope.builtin".quickfix()
require "microscope.builtin".cwd()
require "microscope.builtin".buffer_dir()
```

In your UI of choice, add mappings for other actions than editing the selection
when pressing enter.

- Actions
  - Edit selection
  - Open the selection in a split
  - Open the selection in a vsplit
  - Send all items to the args list
  - Send all items to the quickfix list

Add these mappings to the UI you are using.

```lua
vim.api.nvim_buf_set_keymap(
    "n",
    "<C-S>",
    "<cmd>lua require'microscope.actions'.set_state_and_select('action', 'split')<cr>",
    { noremap = true }
)
```

``action`` can be one of `'split', 'vsplit', 'args', 'quickfix'`.

Use vim.ui.select to go to a location, or set the quickfix/args list to a set of
locations.
