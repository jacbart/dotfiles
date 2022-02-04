local M = {}
function M.configure()
	require('Comment').setup({
		ignore = '^$',
		pre_hook = function(ctx)
			local u = require('Comment.utils')

			local ft = vim.bo.filetype
		end,
	})
end
return M
