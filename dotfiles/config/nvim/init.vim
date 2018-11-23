set number " nuber lines

syntax enable

filetype on " Detect filetype
filetype plugin on " Enable loading filetype plugins
filetype indent on " Smart indentation depending on filetype

" show row and column number in bottom-right
set ruler

" Sets tab to space
set expandtab " defaults to use spaces instead of tabs
set tabstop=4 " size of a hard tabstop
set shiftwidth=4 " size of an "indent"

" Tabs instead of spaces in Makefiles
autocmd FileType make set noexpandtab

" Show non-whitespace characters (tab, newline etc)
set list

" Highlight matches
set hlsearch

" Highlight matches while writing match
set incsearch

" jk is escape
inoremap jk <esc>

" Always have status line for each buffer
set laststatus=2

" Set encoding to utf-8
set encoding=utf-8

" Enable 256 color palette
set t_Co=256

" Scrollwheel
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" Set scrolloff so at least 8 lines above/below cursor are showing
set scrolloff=8

highlight ErrorColor ctermbg=darkred ctermfg=white guibg=#592929
augroup vimrc_error_highlights
  " 1: Highlight when line is longer than 80 chars
  " 2: Highlight trailing whitespace
  autocmd BufEnter * match ErrorColor /\%81v.*\|\s\+\%#\@<!$/
augroup END

" Misc
set background=dark
highlight Visual cterm=reverse gui=reverse
set modelines=0

" Don't redraw while executing macros (improves performance)
set lazyredraw
