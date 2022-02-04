local M = {}

function M.configure()
	vim.cmd([[
    hi CmpItemKind guifg=#928374
    hi CmpItemMenu guifg=#d5c4a1
    ]])
	local cmp = require('cmp')
	local compare = require('cmp.config.compare')
	cmp.setup({
		preselect = cmp.PreselectMode.None,
		mapping = {
			['<CR>'] = cmp.mapping.confirm({
				-- behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
		},
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'path' },
			{ name = 'buffer', keyword_length = 6 },
		},
		sorting = {
			comparators = {
				compare.offset,
				compare.exact,
				compare.score,
				compare.length,
				compare.kind,
				compare.sort_text,
				compare.order,
			},
		},
		formatting = {
			format = function(entry, vim_item)
				vim_item.menu = ({
					path = '[path]',
					luasnip = '[snippet]',
					buffer = '[buffer]',
					nvim_lsp = '[lsp]',
					nvim_lua = '[lua]',
				})[entry.source.name]
				return vim_item
			end,
		},
	})
end
return M