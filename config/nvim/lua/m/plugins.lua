-- ensure packer is installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
	vim.api.nvim_command('packadd packer.nvim')
end

require('packer').startup(function()
  use ({'wbthomason/packer.nvim'})
  use({ 'gruvbox-community/gruvbox' })

  -- lsp
	use({ 'neovim/nvim-lspconfig' })

  use({
			'hrsh7th/nvim-cmp',
			requires = {
				{ 'hrsh7th/cmp-buffer' },
				{ 'hrsh7th/cmp-path' },
				--{ 'hrsh7th/cmp-calc' },
				{ 'hrsh7th/cmp-nvim-lsp' },
				--{ 'saadparwaiz1/cmp_luasnip' },
			},
			config = function()
				require('m/plugins/cmp').configure()
			end,
		})

    -- tabs
		use({
			'akinsho/nvim-bufferline.lua',
			requires = 'kyazdani42/nvim-web-devicons',
			config = function()
				require('bufferline').setup({
					options = {
						diagnostics = 'nvim_lsp',
						separator_style = 'thick',
						max_name_length = 30,
						show_close_icon = false,
						right_mouse_command = nil,
						middle_mouse_command = 'bdelete! %d',
					},
				})
			end,
		})

		use({
			'kyazdani42/nvim-tree.lua',
			requires = { 'kyazdani42/nvim-web-devicons' },
			config = function()
				require('nvim-tree').setup({
					auto_close = true,
					hijack_cursor = true,
					view = {
						width = '30%',
						auto_resize = false,
					},
					filters = {
						dotfiles = true,
					},
					git = {
						enable = true,
						ignore = false,
						timeout = 500,
					},
				})
			end,
			setup = function()
				local c = {
					group_empty = true,
					highlight_opened_files = true,
					window_picker_exclude = {
						filetype = { 'packer', 'tagbar', 'help' },
					},
				}
				for opt, value in pairs(c) do
					if type(value) == 'boolean' then
						value = value and 1 or 0
					end
					vim.g['nvim_tree_' .. opt] = value
				end
				function _G.resize_nvim_tree()
					local percent_as_decimal = 30 / 100
					local width = math.floor(vim.o.columns * percent_as_decimal)
					vim.api.nvim_win_set_width(require('nvim-tree.view').get_winnr(), width)
				end
			end,
		})
    use({ 'lewis6991/impatient.nvim' })
end)
