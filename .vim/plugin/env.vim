scriptencoding utf-8

augroup autocmd_env
  au!
  au BufNewFile,BufRead * call s:load_proj()
augroup end

function! s:load_proj() abort
  if filereadable ('proj.vim')
    so .proj.vim
  endif
endfunction
