local lspconfig = require('lspconfig')

local function make_base_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
	return { capabilities = capabilities, on_attach = on_attach }
end

-- LSP Setup
local function setup()
	local lsp_configs = require('m/lsp/config')

	for lsp, lsp_config in pairs(lsp_configs) do
		local config = vim.tbl_deep_extend('force', make_base_config(), lsp_config)
		lspconfig[lsp].setup(config)
	end
end

setup()
