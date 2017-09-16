if has('win32')
  set guifont=ubuntu_mono:h13.5
  set guifontwide=NasuM:h12
endif
if has('unix')
  set guifont=Ubuntu\ Mono\ 13.5
  set guifontwide=Ubuntu\ Mono\ 13.5
endif

set iminsert=0
set imsearch=1
set guioptions-=m
set guioptions-=T
set runtimepath+=~/.gvim,~/.gvim/after
