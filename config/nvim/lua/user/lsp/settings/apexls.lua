local apex = {}

function apex.setup()
  local lspconfig = require'lspconfig'
  local configs = require'lspconfig.configs'
  configs.apexls = {
    default_config = {
      cmd = { 'java', '-jar', vim.fn.stdpath("data")..'/lsp_servers/apex/apex-jorje-lsp.jar' },
      filetypes = { 'cls', 'trigger', 'apex' },
      root_dir = lspconfig.util.root_pattern('sfdx-project.json'),
      settings = {},
    },
  }
  lspconfig["apexls"].setup({
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  })
  vim.cmd[[
    au BufRead,BufNewFile *.cls,*.trigger,*.apex set filetype=apex
  ]]
end

return apex
