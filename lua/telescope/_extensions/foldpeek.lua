local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local foldpeek = require("foldpeek")

local function get_folded_regions()
  local results = {}
  local bufnr = vim.api.nvim_get_current_buf()
  local total_lines = vim.api.nvim_buf_line_count(bufnr)

  local lnum = 1
  while lnum <= total_lines do
    local folded = vim.fn.foldclosed(lnum)
    if folded ~= -1 then
      local end_lnum = vim.fn.foldclosedend(lnum)
      local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, end_lnum, false)
      table.insert(results, {
        display = string.format("L%d-L%d: %s", lnum, end_lnum, vim.trim(lines[1] or "")),
        lnum = lnum,
        end_lnum = end_lnum,
        lines = lines,
      })
      lnum = end_lnum + 1
    else
      lnum = lnum + 1
    end
  end

  return results
end

-- Pass the original filetype to the previewer
local function folds_picker(opts)
  opts = opts or {}

  -- Capture the original buffer's filetype before initializing the picker
  local original_filetype = vim.api.nvim_buf_get_option(0, "filetype")

  local results = get_folded_regions()

  pickers.new(opts, {
    prompt_title = "Folded Regions",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display,
          ordinal = entry.display,
          lnum = entry.lnum,
        }
      end
    },
    previewer = previewers.new_buffer_previewer {
      define_preview = function(self, entry, _)
        local bufnr = self.state.bufnr
        local lines = entry.value.lines or {}

        -- Set buffer lines and make it read-only
        vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

        -- Apply the original filetype to the preview buffer immediately
        vim.api.nvim_buf_set_option(bufnr, "filetype", original_filetype)

        -- Safeguard: Skip Treesitter and filetype plugins for invalid filetypes
        if not original_filetype or original_filetype == "TelescopePrompt" then
          vim.notify("Skipping Treesitter and filetype plugins for filetype: " .. (original_filetype or "nil"), vim.log.levels.WARN)
          return
        end

        -- Debug: Log the corrected filetype being set
        vim.notify("Corrected preview buffer filetype: " .. original_filetype, vim.log.levels.INFO)

        -- Explicitly enable syntax highlighting globally
        vim.cmd("syntax on")

        -- Verify the buffer's filetype before invoking Treesitter
        local current_filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
        if current_filetype ~= original_filetype then
          vim.notify("Skipping Treesitter: Buffer filetype mismatch (expected: " .. original_filetype .. ", got: " .. current_filetype .. ")", vim.log.levels.WARN)
          return
        end

        -- Debug: Log the filetype verification
        vim.notify("Verified buffer filetype: " .. current_filetype, vim.log.levels.INFO)

        -- Map filetype to Treesitter language parser if necessary
        local ts_language = original_filetype
        if original_filetype == "lua" then
          ts_language = "lua" -- Example mapping, adjust as needed
        end

        -- Force Treesitter highlighting (if available)
        if pcall(require, "nvim-treesitter") then
          local ts_ok, ts = pcall(vim.treesitter.start, bufnr, ts_language)
          if not ts_ok then
            vim.notify("Treesitter failed to start for language: " .. ts_language, vim.log.levels.WARN)
          end
        else
          vim.notify("nvim-treesitter is not available", vim.log.levels.WARN)
        end

        -- Optional: tweak window-local options
        if self.state.winid then
          vim.wo[self.state.winid].wrap = false
          vim.wo[self.state.winid].conceallevel = 0
        end
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        if entry then
          vim.api.nvim_win_set_cursor(0, { entry.lnum, 0 })
          foldpeek.preview()
        end
      end)
      return true
    end,
  }):find()
end

return require("telescope").register_extension({
  exports = {
    folds = folds_picker
  }
})
