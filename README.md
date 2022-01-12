# microscope.nvim

Send lists of file locations to vim.ui.select. Similar to Telescope, but without
the UI.

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
    "<cmd>lua require'microscope.actions'.set_action_and_select('split')<cr>",
    { noremap = true }
)
```

`action` can be one of `'split', 'vsplit', 'args', 'quickfix'`.
