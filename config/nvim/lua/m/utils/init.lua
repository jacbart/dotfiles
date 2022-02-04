local M = {}

function M.sync_nvim_tree_width()
  local width = vim.g.nvim_tree_auto_width
  if type(vim.g.nvim_tree_auto_width) == "string" then
    local as_number = tonumber(vim.g.nvim_tree_auto_width:sub(0, -2))
    width = math.floor(vim.o.columns * (as_number / 100))
  end
  vim.api.nvim_win_set_width(require('nvim-tree.view').get_winnr(), width)
end
