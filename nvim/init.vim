set number
set tabstop=2 shiftwidth=2 expandtab
set mouse=a
filetype plugin indent on
set shell=/bin/zsh
" use system clipboard
set clipboard+=unnamedplus,unnamed
" allow unsaved buffers
set hidden


"==============================
"=========== Plugins ==========
"==============================
call plug#begin('~/.config/nvim/plugged')
""" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" keybind
nnoremap <C-p> :Files<CR>
Plug 'lambdalisue/fern.vim'
" Plug 'lambdalisue/nerdfont.vim'
" Plug 'lambdalisue/fern-renderer-nerdfont.vim'
" let g:fern#renderer = 'nerdfont'
let g:fern#disable_default_mappings = 1
""" tmux-navigator
Plug 'christoomey/vim-tmux-navigator'
let g:tmux_navigator_no_mappings = 1
"~~~~ code ~~~~
""" rest.vim
" Plug 'taybart/rest.vim'
" Plug 'transcoder'
""" tagbar
Plug 'majutsushi/tagbar'
""" coc.vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Better display for messages
" set cmdheight=2
" set updatetime=300
let g:coc_enable_locationlist = 0
let g:coc_global_extensions = [
  \'coc-go',
  \'coc-tsserver',
  \'coc-prettier',
  \'coc-eslint',
  \'coc-html',
  \'coc-json',
  \'coc-yaml',
\]
au BufRead,BufNewFile *.tmpl setfiletype gohtmltmpl
  " \'coc-css',
""" base64
Plug 'christianrondeau/vim-base64'
""" polyglot
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['markdown']
""" neosnippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
""" Nerd Commenter " good bye sweet prince...me want to get closers to vim
" Plug 'scrooloose/nerdcommenter'
" let g:NERDSpaceDelims = 1
""" 🙏 the pope
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'go', 'javascript']
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
command! G Ge :
"~~~~ looks ~~~~
Plug 'ayu-theme/ayu-vim' " or other package manager
set termguicolors
let ayucolor="dark"   " for dark version of theme
colorscheme ayu
""" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 0
""" Questionable
Plug 'ntpeters/vim-better-whitespace'
Plug 'unblevable/quick-scope'
Plug 'dyng/ctrlsf.vim'
call plug#end()

"==============================
"======== Keybindings =========
"==============================
let mapleader = "\<Space>"

" Quickly open/reload vim
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" base64
vnoremap <silent> <leader>bd :<c-u>call base64#v_atob()<cr>
vnoremap <silent> <leader>be :<c-u>call base64#v_btoa()<cr>

" tmux integration
nnoremap <silent> <c-m> :TmuxNavigateDown<CR>
nnoremap <silent> <c-u> :TmuxNavigateUp<CR>
nnoremap <silent> <c-l> :TmuxNavigateRight<CR>
nnoremap <silent> <c-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-;> :TmuxNavigatePrevious<cr>

" fern
noremap <silent> <Leader>f :Fern . -drawer -reveal=% -toggle -width=35<CR>


" ------------------------------ fern -----------------------------------------

" Disable netrw.
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

augroup my-fern-hijack
  autocmd!
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END


function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction

function! FernInit() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer><nowait> d <Plug>(fern-action-remove)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> M <Plug>(fern-action-rename)
  nmap <buffer> h <Plug>(fern-action-hidden-toggle)
  nmap <buffer> R <Plug>(fern-action-reload)
  nmap <buffer> e <Plug>(fern-action-mark:toggle)
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
