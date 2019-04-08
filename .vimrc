" + --------------------------------- +
" | ~  Andrej Nano's custom .vimrc  ~ |
" + --------------------------------- +
" | Last updated: APR 2019            |
" +----------------------------------- 

" Solarized Dark Theme
set background=dark
colorscheme solarized
let g:solarized_termtrans=1

" restrict the usage of some commands in non-default .vimrc files
set exrc
set secure

" UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
set encoding=utf-8 nobomb

" disable vi compatibility (emulation of old bugs)
set nocompatible

" use indentation of previous line
"set autoindent

" use intelligent indentation for C
"set smartindent

" configure tabwidth and insert spaces instead of tabs
set tabstop=2        " tab width is 2 spaces
"set shiftwidth=2     " indent also with  spaces
"set expandtab        " expand tabs to spaces

" wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
set textwidth=120

" turn syntax highlighting on
set t_Co=256
syntax on

" turn line numbers on
set number

" highlight matching braces
"set showmatch


" highlight search
set hlsearch
" ignore case of searches
set ignorecase
" highlight dynamically as pattern is typed
set incsearch


" -- Binding
" move vertically by visual line
nnoremap j gj
nnoremap k gk
"imap T ^
imap ii <Esc>


" -- misc --
set ttyfast
set backspace=indent,eol,start
set scrolloff=3


" -- enable Pathogen plugin manager
" execute pathogen#infect()


" Use the OS clipboard by default
set clipboard=unnamed

" Enhance command-line completion
set wildmenu

" Allow cursor keys in insert mode
set esckeys

" Add the g flag to search/replace by deafult
set gdefault

" Change mapleader
let mapleader=","

" Don't add empty newlines at the end of files
set binary
set noeol

" Centralize backups, swafiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
    set undodir=~/.vim/undo
endif


" Don't create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4

" Highlight current line
set cursorline

" Show 'invisible' characters
"set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
"set list


" Always show status line
set laststatus=2

" Enable mouse in all modes
set mouse=a

" Disable error bells
set noerrorbells

" Don't reset cursor to start of line when moving around
set nostartofline

" Show the cursor position
set ruler

" Don't show the intro message when starting vim
set shortmess=atI

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title

" Show the (partial) command as it's being typed
set showcmd

" Use relative line numbers
if exists("&relativenumber")
    set relativenumber
    au BufReadPost * set relativenumber
endif

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
        " Enable file type detection
        filetype on
        " Treat .json files as .js
        autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
        " Treat .md files as Markdown
        autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif





















