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

  " read reveal.js config from .vimrc
  let separator = get(g:, 'mdslide_data_separator', '^\r?\n---\r?\n$')
  let separator_vertical = get(g:, 'mdslide_data_separator_vertical', '^\r?\n\r?\n\r?\n')
  let separator_notes = get(g:, 'mdslide_data_separator_notes', '^note:')
  let charset = get(g:, 'mdslide_data_charset', 'utf-8')

  " generate mdslide.js
  let tpl_path = s:base_dir . '/view/js/mdslide/mdslide.js.tpl'
  if !filereadable(tpl_path)
    echohl ErrorMsg
    echo 'view/js/mdslide/mdslide.js.tpl is not exists. Please reinstall mdslide.vim.'
    echohl None
    return
  endif

  let js_content = []
  let re_sep = '\v\{\{\s*separator\s*}}'
  let re_sep_vert = '\v\{\{\s*separator_vertical\s*}}'
  let re_sep_notes = '\v\{\{\s*separator_notes\s*}}'
  let re_charset = '\v\{\{\s*charset\s*}}'
  for line in readfile(tpl_path)
    if line =~# re_sep
      let line = substitute(line, re_sep, separator, '')
    elseif line =~# re_sep_vert
      let line = substitute(line, re_sep_vert, separator_vertical, '')
    elseif line =~# re_sep_notes
      let line = substitute(line, re_sep_notes, separator_notes, '')
    elseif line =~# re_charset
      let line = substitute(line, re_charset, charset, '')
    endif

    call add(js_content, line)
  endfor

  let js_path = s:base_dir . '/view/js/mdslide/mdslide.js'
  call writefile(js_content, js_path)

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

if !exists(":MdRestartServer")
  command! -nargs=0 MdRestartServer :call mdslide#restartServer()
endif

if !exists(":MdServerStatus")
  command! -nargs=0 MdServerStatus :call mdslide#getServerStatus()
endif

augroup MdSlide
  autocmd FileType markdown :call s:init()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
