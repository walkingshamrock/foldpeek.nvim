local M = {}

local config = {
  auto_open = false -- default behavior: manual only
}

local ns = vim.api.nvim_create_namespace("foldpeek")
local win_id = nil
local buf_id = nil

function M.peek()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  if vim.fn.foldclosed(line) == -1 then
    print("Not a folded line")
    return
  end

  local start_line = vim.fn.foldclosed(line) - 1
  local end_line = vim.fn.foldclosedend(line)
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end

  buf_id = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

  -- Match the filetype of the original buffer for syntax highlighting
  local original_ft = vim.api.nvim_buf_get_option(0, "filetype")
  vim.api.nvim_buf_set_option(buf_id, "filetype", original_ft)

  local width = math.max(40, math.floor(vim.o.columns * 0.4))
  local height = math.min(#lines, 10)

  win_id = vim.api.nvim_open_win(buf_id, false, {
    relative = "cursor",
    row = 1,
    col = 1,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded"
  })

  -- Close on CursorMoved
  vim.cmd([[autocmd CursorMoved * ++once lua pcall(require('foldpeek').close)]])
end

function M.close()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
    win_id = nil
  end
end

function M.setup(user_config)
  if user_config then
    config = vim.tbl_deep_extend("force", config, user_config)
  end

  vim.api.nvim_create_user_command("Foldpeek", M.peek, {})

  if config.auto_open then
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        if vim.fn.foldclosed(line) ~= -1 then
          pcall(require("foldpeek").peek)
        end
      end,
      desc = "Auto open foldpeek on CursorHold when on folded line",
    })
  end
end

return M