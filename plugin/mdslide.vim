" Generate Web based slide with Markdown and reveal.js
" Author: mas9612 <mas9612@gmail.com>
" License: This file is placed in the public domain.

if exists("g:loaded_mdslide")
  finish
endif
let g:loaded_mdslide = 1

let s:save_cpo = &cpo
set cpo&vim

augroup MdSlide
  autocmd!
augroup END

let s:base_dir = expand('<sfile>:p:h:h')
function! s:init()
  " If view/js/mdslide/contents.js is not exists, create it.
  if !filereadable(s:base_dir . '/view/js/mdslide/contents.js')
    execute "redir > " . s:base_dir . '/view/js/mdslide/contents.js'
    redir END
  endif

  augroup MdSlide
    autocmd BufWritePost <buffer> :call mdslide#refresh_content()
  augroup END
endfunction

if !exists(":MdOpenSlide")
  command! -nargs=0 MdOpenSlide :call mdslide#openBrowser()
endif

if !exists(":MdRefreshContent")
  command! -nargs=0 MdRefreshContent :call mdslide#refresh_content()
endif

if !exists(":MdStartServer")
  command! -nargs=0 MdStartServer :call mdslide#startServer()
endif

if !exists(":MdStopServer")
  command! -nargs=0 MdStopServer :call mdslide#stopServer()
endif

augroup MdSlide
  autocmd FileType markdown :call s:init()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
