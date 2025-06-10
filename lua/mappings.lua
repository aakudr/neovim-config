require "nvchad.mappings"
local harpoon = require "harpoon"

local M = {}

-- add yours here

local map = vim.keymap.set

local hover_action = function()
  local dap = require "dap"
  if next(dap.sessions()) ~= nil then
    local view = require("dap.ui.widgets").hover()
    vim.keymap.set("n", "q", view.close, { buffer = view.buf, desc = "Close inspector" })
    vim.keymap.set(
      "n",
      "g",
      "<Cmd>lua require('dap.ui').trigger_actions({ mode = 'first' })<CR>",
      { buffer = view.buf, desc = "Expand", nowait = true }
    )
    vim.print(view)
  else
    vim.lsp.buf.hover()
  end
end
hover_action()

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>fM", vim.lsp.buf.format)

-- Telescope grep directoryy
map("n", "<leader>cd", function()
  -- do something
  -- function(prompt_bufnr)
  local selection = require("telescope.actions.state").get_selected_entry()
  local dir = vim.fn.fnamemodify(selection.path, ":p:h")
  require("telescope.actions").close(prompt_bufnr)
  -- Depending on what you want put `cd`, `lcd`, `tcd`
  vim.cmd(string.format("silent lcd %s", dir))
end, { desc = "Terminal toggle floating" })
