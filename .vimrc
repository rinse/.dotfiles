" setting
scriptencoding utf-8
set encoding=utf8
set fileencoding=utf-8
set fileencodings=utf-8,sjis,utf-16le,utf-16,euc-jp
set fileformats=unix,dos
set number
set cursorline
set showmatch
set matchtime=1
set wrap
set hlsearch
set pumheight=10
set nobackup
set noundofile
set noignorecase
set wildmenu  " make <Tab> show completions in command line mode.
set wildmode=longest:full,full
set ambiwidth=double
set splitbelow
set splitright
set laststatus=2

" clipboard
if has("X11")
  set clipboard&
  set clipboard^=unnamedplus
endif

if v:version >= 800
  set breakindent
endif

" tab, space
set expandtab " <Tab> produces spaces
" how many columns text is indented with the reindent operations; << and >>
set shiftwidth=4
" how many columns a tab counts for
set tabstop=4
" how many columns vim uses when you hit Tab in insert mode
set softtabstop=4
" round indent to multiple of 'shiftwidth'
set shiftround
set list
set listchars=tab:>\ 


" indent settings
set autoindent
set smartindent " ignored by cindent
set cindent


" backspace
set backspace=indent,eol,start


" keymaps
let mapleader = "m"
nnoremap <Leader>m m
noremap <Leader>y "+y
noremap <Leader>Y "+Y
noremap <Leader>d "+d
noremap <Leader>D "+D
noremap <Leader>p "+p
noremap <Leader>P "+P

" other keymaps
nnoremap Y y$
nnoremap r <C-r>
nnoremap / /\v
nnoremap ? ?\v
nnoremap <C-]> g<c-]>
noremap + <C-a>
noremap - <C-x>

cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>

vnoremap <C-h>  "zdh"zP`[<C-v>`]
vnoremap <C-j>  "zdj"zP`[<C-v>`]
vnoremap <C-k>  "zdk"zP`[<C-v>`]
vnoremap <C-l>  "zd"zp`[<C-v>`] 

" enable ftplugins
filetype plugin on
" disable ftplugins keymappings
let no_plugin_maps = 1

set runtimepath^=~/.vim
set runtimepath+=~/.vim/after

set tags+=.git/tags

" load common syntax file to all filetypes
au VimEnter,BufEnter * call s:LoadGeneralSyntax()
au VimEnter,BufEnter * call s:LoadGeneralAfterSyntax()

" use a dark colourscheme
set background=dark

function! s:LoadGeneralSyntax() abort
  if exists('g:syntax_on')
    ru! syntax/_.vim
  endif
endfunction
function! s:LoadGeneralAfterSyntax() abort
  if exists('g:syntax_on')
    ru! after/syntax/_.vim
  endif
endfunction
