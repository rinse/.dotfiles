scriptencoding utf-8

" stylish-haskell integration
augroup autocmd_env
  autocmd!
  autocmd BufWrite *.hs silent call s:StylishHaskell()
augroup end

function! s:StylishHaskell() abort
  if executable('stylish-haskell')
    let l:pos = getpos('.')
    %!stylish-haskell
    if v:shell_error
      undo
    endif
    call setpos('.', l:pos)
  endif
endfunction
