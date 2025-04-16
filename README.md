# foldpeek.nvim

`foldpeek.nvim` is a Neovim plugin designed to enhance your workflow by providing advanced folding and peeking capabilities.

## Features

- **Advanced Folding**: Intelligently fold code blocks for better readability.
- **Peek Functionality**: Quickly preview folded sections without unfolding them.

## Installation

Use your favorite Neovim plugin manager to install `foldpeek.nvim`. For example, using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use { 'walkingshamrock/foldpeek.nvim' }
```

## Usage

Add the following configuration to your `init.lua` or `init.vim`:

```lua
require('foldpeek').setup({
  -- Add your configuration options here
})
```

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
