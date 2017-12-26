scriptencoding utf-8

if !exists('g:enabled_wandbox_vim')
  finish
endif

if exists('g:loaded_wandbox_vim_setting')
  finish
endif
let g:loaded_wandbox_vim_setting = 1


" Set default compilers for each filetype
let g:wandbox#default_compiler = {
\   'cpp' : 'clang-head',
\ }


" Set default options for each filetype.
" Type of value is string or list of string.
let g:wandbox#default_options = {
\   'cpp' : [
\     '-Wall,-Wextra',
\     '-std=c++2a',
\     '-O2',
\     'boost-1.66',
\     'sprout',
\   ],
\ }


" Set extra options for compilers if you need
let g:wandbox#default_extra_options = {
\   'clang-head' : [ '-std=c++2a', ],
\   'gcc-head' : [ '-std=c++2a', ],
\ }
