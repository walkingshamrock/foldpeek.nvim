if vim.fn.has("nvim-0.7") == 0 then
  vim.api.nvim_err_writeln("foldpeek.nvim requires Neovim 0.7 or higher")
  return
end

require("foldpeek").setup()
