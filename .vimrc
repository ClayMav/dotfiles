if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" ====== Aesthetics ======
" Color Scheme
Plug 'sonph/onehalf', { 'rtp': 'vim/' }
" Fancy status bar
" Plug 'itchyny/lightline.vim'

" ====== Utility ======
" Comment with gcc or gc
Plug 'tpope/vim-commentary'
" Pairs of parens etc.
Plug 'tmsvg/pear-tree'
" Fuzzy File Finder
" Plug 'kien/ctrlp.vim'
" Linting and language server integrations
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
" Adds character to denote level of indent
Plug 'Yggdroot/indentLine'

" ====== Language Specific ======
" Python
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
Plug 'vim-python/python-syntax', { 'for': 'python' }
" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jparise/vim-graphql'
" TypeScript
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
" JSON
Plug 'elzr/vim-json'

call plug#end()

" ====== Vim Styling ======
" -------------------------

colorscheme onehalfdark

" Allow Italics
hi Comment cterm=italic

" Make background transparent
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

" Enable true colors
if has('nvim') || has('termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" ====== Plugin Config ======
" ---------------------------

" coc.nvim extensions
let g:coc_global_extensions = [
      \'coc-tsserver',
      \'coc-eslint',
      \'coc-prettier',
      \'coc-python',
      \'coc-json'
      \]

" IndentLine
let g:indentLine_char = '│'
let g:vim_json_syntax_conceal = 0

" python-syntax
let g:python_highlight_all = 1

" Smart pairs
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1

" ====== Overwrites ======
" keys I don't want to hit
" ------------------------
let mapleader = ','

map Q <nop>
map <F1> <Esc>
imap <F1> <Esc>
map <C-P> :Files<CR>

" ====== Vim Settings ======
" --------------------------
" Set utf8
set encoding=utf-8

" Enable mouse interactions
set mouse=a

" Fix stuff in macos
if !has('nvim')
  " MacOS uses the wrong backspace character
  set backspace=2
else
  " without this, it just wonks
  set nofsync
endif

" EOL chars for looks
set list
set listchars=tab:▸\ ,eol:¬


" Turn on syntax highlighting
if !exists("g:syntax_on")
  syntax enable
  set re=0
endif

" General tab adjustments
set tabstop=8
set expandtab
set softtabstop=2
set shiftwidth=2

" hybrid line numbers show current and offsets from current
set number
set relativenumber

" 80 char color column denotes limit
set colorcolumn=80

" TODO find out what this does
set hidden

" shows cursor position in bottom right
set ruler

" show search results live
set incsearch
set hlsearch
set ignorecase
set smartcase

" Backup, undo, and swap files
" run  mkdir ~/.vim/.backup ~/.vim/.swp ~/.vim/.undo first
set undodir=~/.vim/.undo//
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//
set backup
set undofile

" ====== Scripts ======
" ---------------------

" Return to the same line when you reopen a file.
augroup line_return
      au!
          au BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \ execute 'normal! g`"zvzz' |
                \ endif
        augroup END


" ====== Language Settings ======
" -------------------------------
" Python specific
autocmd Filetype python setlocal expandtab shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
