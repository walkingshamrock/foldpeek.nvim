# foldpeek.nvim

![screenshot](screenshot.png)

`foldpeek.nvim` is a Neovim plugin designed to enhance your workflow by providing advanced folding and peeking capabilities.

Thank you for considering supporting this project! Your generosity helps keep development active and ensures the plugin continues to improve.

[![Buy Me A Coffee](https://img.shields.io/badge/-Buy%20me%20a%20coffee-yellow?style=for-the-badge&logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/walkingshamrock)

## Features

- **Advanced Folding**: Intelligently fold code blocks for better readability.
- **Peek Functionality**: Quickly preview folded sections without unfolding them.
- **Auto Open**: Automatically peek into folded sections when the cursor hovers over them (configurable).

## Installation

Use your favorite Neovim plugin manager to install `foldpeek.nvim`. For example, using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
require('lazy').setup({
  { 'walkingshamrock/foldpeek.nvim' }
})
```

## Usage

Add the following configuration to your `init.lua` or `init.vim`:

```lua
require('foldpeek').setup({
  auto_open = true, -- Automatically peek into folds on CursorHold
})
```

### Commands

- `:Foldpeek`: Manually peek into the folded section under the cursor.

### Auto Open

When `auto_open` is enabled, the plugin will automatically peek into folded sections when the cursor hovers over them for a moment (triggered by the `CursorHold` event).

### Adjusting the Time Until Foldpeek Opens

The time until the `foldpeek` window opens is determined by the `CursorHold` event, which is triggered after a delay specified by the `updatetime` option in Neovim. To adjust this delay, set the `updatetime` value in your Neovim configuration:

```vim
" Set the delay for CursorHold (in milliseconds)
set updatetime=300
```

For example, setting `updatetime` to `300` means the `CursorHold` event will trigger after 300ms of inactivity, causing the `foldpeek` window to open if `auto_open` is enabled.

## Configuration

The `setup` function accepts a configuration table. Below are the available options:

- `auto_open` (boolean): If `true`, automatically peek into folds on `CursorHold`. Default is `false`.

Example:

```lua
require('foldpeek').setup({
  auto_open = false, -- Default behavior: manual peeking only
})
```

## Telescope Integration

`foldpeek.nvim` now includes a Telescope extension to enhance your workflow by allowing you to explore and preview folded regions in your buffer. This integration provides a seamless way to navigate folded sections using Telescope's powerful interface.

### Usage

To use the Telescope integration, load the `foldpeek` extension and invoke the `folds` picker:

```lua
require('telescope').load_extension('foldpeek')
require('telescope').extensions.foldpeek.folds()
```

This will open a Telescope picker displaying all folded regions in the current buffer. Selecting an entry will move the cursor to the corresponding folded section.

### Additional Command

You can also invoke the Telescope integration using the following command:

```vim
:Telescope foldpeek folds
```

This command opens the Telescope picker for the current buffer, displaying all folded regions. The preview window will show the unfolded content of the selected fold, allowing you to inspect it without modifying the buffer.

### Features

- **Preview Folded Regions**: Quickly preview the content of folded sections without unfolding them.
- **Navigate Folds**: Easily jump to any folded section in your buffer.

This integration leverages Telescope's previewer to display the content of folded regions, ensuring a smooth and efficient workflow.

## License

This plugin is licensed under the MIT License. See the `LICENSE` file for details.
