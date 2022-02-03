-- helpful things
local u = require('m/utils/maps')

vim.g.mapleader = " " -- space as leader

-- drawer
u.mode_map_group('n', {
  {'<Leader>f', ':NvimTreeToggle<cr>'},
  {'<Leader>F', ':NvimTreeFindFile<cr>'}
}, {noremap = true, silent = true})