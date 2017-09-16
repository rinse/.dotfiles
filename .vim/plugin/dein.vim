" settings of dein.vim

if !executable('git')
  finish
endif

augroup DeinAutoCmd
  autocmd!
augroup END

" directory of the cache
let s:cache_home =
  \empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CASHE_HOME
let s:dein_dir = s:cache_home . '/dein'
" directory of dein.vim
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" clones dein.vim if needed.
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

" make sure the runtimepath.
let &runtimepath = s:dein_repo_dir . ',' . &runtimepath

" settings of dein.vim.
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " TOML files that contains the plugin lists.
  " prepares TOML files in before.
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " load TOML files and cache them
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " setting finished
  call dein#end()
  call dein#save_state()
endif

" install plugins that aren't installed yet.
if dein#check_install()
  call dein#install()
endif

syntax enable
runtime! plugin_settings/*.vim

