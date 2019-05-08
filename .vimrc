if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')


" Color Scheme
Plug 'sonph/onehalf', { 'rtp': 'vim/' }

" Press % to go to matching tag
" Plug 'adelarsq/vim-matchit'

" Shows how outdented you are
Plug 'Yggdroot/indentLine'

" Fuzzy File Finder
" Plug 'kien/ctrlp.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Fancy bar at bottom of vim
Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Auto closing of parens and quotes and such
Plug 'tpope/vim-surround'
"
" Linting
Plug 'w0rp/ale'

" Git Gutter, changes shown
Plug 'airblade/vim-gitgutter'

" Python
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
Plug 'vim-python/python-syntax', { 'for': 'python' }

" Typescript
Plug 'leafgarland/typescript-vim'

" Vue
Plug 'posva/vim-vue'

" Markdown
Plug 'JamshedVesuna/vim-markdown-preview', { 'for': 'markdown' }

Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

call plug#end()

" Beautify Everything
" -----------------------

" colorscheme space-vim-dark
colorscheme onehalfdark

" Allow Italics
hi Comment cterm=italic

" Make background transparent
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE

" let g:airline_theme='violet'
let g:airline_theme='onehalfdark'

" Enable true colors
if has('nvim') || has('termguicolors')
  set termguicolors
endif

" Plugins and their Settings
" ------------------------


let g:livepreview_previewer = 'open -a Skim'

" IndentLine
let g:indentLine_char = '│'

" Ale
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['pylint'],
\   'latex': ['alex', 'redpen', 'vale'],
\   'typescript': ['tslint']
\}
let g:ale_fixers = {
\   'python': ['yapf', 'isort'],
\   'cpp': ['clang-format'],
\   'css': ['prettier'],
\   'html': ['tidy'],
\   'javascript': ['eslint', 'prettier'],
\   'go': ['gofmt'],
\   'typescript': ['tslint', 'prettier']
\}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1

" Markdown
let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<C-m>'

" python-syntax
let g:python_highlight_all = 1

" Airline
let g:airline#extensions#ale#enabled = 1
" Allows airline to run constantly
set laststatus=2
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:indentLine_setConceal = 0

" Overwrites (keys I don't want to hit)
" -----------------------
let mapleader = ','

map Q <nop>
map <F1> <Esc>
imap <F1> <Esc>

"FZF
" nmap ; :Buffers<CR>
map <C-P> :Files<CR>
" map <Leader>t :Files<CR>
" nmap <Leader>r :Tags<CR>

" Set utf8
set encoding=utf-8

" Set mouse
set mouse=a

" Fix stuff in macos
if !has('nvim')
  set backspace=2
else
  set nofsync
endif

" EOL chars
set list
set listchars=tab:▸\ ,eol:¬


" Turn on syntax highlighting
if !exists("g:syntax_on")
  syntax enable
endif

" General tab adjustments
set tabstop=8
set expandtab

set softtabstop=2
set shiftwidth=2

" hybrid line numbers
set number
set relativenumber

" 80 char color column denotes limit
set colorcolumn=80

" TODO find out what this does
set nobackup

" TODO find out what this does
set hidden

" shows cursor position in bottom right
set ruler

" show search results live
set incsearch
set hlsearch
set ignorecase
set smartcase

" Command completion
" set wildmenu
" set wildmode=longest:full,full

" Scripts
" -------------------

" Return to the same line when you reopen a file.
augroup line_return
      au!
          au BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \ execute 'normal! g`"zvzz' |
                \ endif
        augroup END

" Python specific
autocmd Filetype python setlocal expandtab shiftwidth=4 softtabstop=4

" Add language specific filed
