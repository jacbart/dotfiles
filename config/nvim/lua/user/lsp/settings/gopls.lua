
local go = {}

function go.un(file_name)
  if not file_name then
    file_name = '.'
  end
  vim.api.nvim_command('!go run '..file_name)
end

function go.on_save()
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local action = "textDocument/codeAction"
  local result = vim.lsp.buf_request_sync(0, action, params, 500)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
  vim.lsp.buf.formatting_sync()
end

return go
