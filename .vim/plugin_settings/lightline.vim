scriptencoding utf-8

if !exists('g:enabled_lightline')
  finish
endif

if exists('g:loaded_lightline_setting')
  finish
endif
let g:loaded_lightline_setting = 1

if !has('gui_running')
  set t_Co=256
endif
set noshowmode

let g:lightline = {
  \ 'colorscheme' : 'one',
  \ 'active' : {
    \ 'left' : [
      \ ['mode', 'paste'],
      \ ['readonly', 'fugitive', 'bufnum', 'filename', 'modified']
    \ ],
    \ 'right' : [
      \ ['filetype', 'fileencoding', 'bomb', 'fileformat']
    \ ]
  \ },
  \ 'inactive' : {
    \ 'left' : [
      \ ['readonly', 'fugitive', 'bufnum', 'filename', 'modified']
    \ ],
    \ 'right' : [
      \ ['filetype', 'fileencoding', 'bomb', 'fileformat']
    \ ]
  \ },
  \ 'component' : {
    \ 'filetype': '%{&ft !=# "" ? &ft : "noft"}'
  \ },
  \ 'component_function' : {
    \ 'fugitive' : 'LightlineFugitive',
    \ 'bomb' : 'LightlineBomb'
  \ }
\ }


function! LightlineFugitive() abort
  if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
    return fugitive#head()
  else
    return ''
  endif
endfunction

function! LightlineBomb() abort
  if &fileencoding ==? 'utf-8' || &fileencoding ==? 'utf-16le' || &fileencoding ==? 'utf-16'
    return &bomb == 0 ? 'nobom' : 'bom'
  else
    return ''
  endif
endfunction
