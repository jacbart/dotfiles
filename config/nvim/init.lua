-- use zsh as shell
vim.opt.shell = '/bin/zsh'

-- use system clipboard
vim.opt.clipboard:prepend({'unnamedplus'})

-- use 2 spaes as tabs and always
-- expand to spaces
vim.opt.expandtab=true
vim.opt.tabstop=2
vim.opt.shiftwidth=2
vim.opt.softtabstop=2

-- allow unsaved buffers
vim.opt.hidden=true

-- better completion actions
vim.opt.completeopt={'menuone','noinsert','noselect'}

-- cleaner completions
vim.opt.shortmess:append('c')

-- allow mouse scrolling
vim.opt.mouse='a'

-- line numbers
vim.opt.number=true

-- allow more complicated font/color stuff
vim.opt.termguicolors=true

require ('m/keymaps')
require ('m/plugins')
require ('m/looks')

require ('m/lsp')
