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

function! s:init()
  augroup MdSlide
    autocmd BufWritePost <buffer> :call s:refresh_content()
  augroup END
endfunction

function! s:openBrowser()
  call system("open http://localhost:8000")
endfunction

function! s:startServer()
  call system("./server.py &")
endfunction

function! s:stopServer()
  let pid = system("ps aux | grep \"[s]erver.py\" | awk '{print $2}'")
  let command = "kill " . pid
  call system(command)
endfunction

let s:dir_path = expand('<sfile>:p:h')
function! s:refresh_content()
  " read from current file
  let contents = getline(1, '$')

  let escaped = []
  " js escape strings
  for line in contents
    let line = substitute(line, '\\', '\\\\', 'g')
    let line = substitute(line, '"', '\\"', 'g')
    let line = substitute(line, '''', '\\''', 'g')
    call add(escaped, line)
  endfor

  " TODO: convert relative image path to absolute path

  " write entire contents to content.js
  let output_path = s:dir_path . '/js/mdslide/contents.js'

  call writefile([
    \ 'function filepath() {',
    \ printf('    return "%s";', expand('%:p')),
    \ '}',
    \ 'function last_modified() {',
    \ printf('    return "%s";', localtime()),
    \ '}',
    \ 'function contents() {',
    \ printf('    return "%s";', join(escaped, '\n')),
    \ '}'
    \], output_path)
endfunction

if !exists(":MdOpenSlide")
  command! -nargs=0 MdOpenSlide :call s:openBrowser()
endif

if !exists(":MdRefreshContent")
  command! -nargs=0 MdRefreshContent :call s:refresh_content()
endif

if !exists(":MdStartServer")
  command! -nargs=0 MdStartServer :call s:startServer()
endif

if !exists(":MdStopServer")
  command! -nargs=0 MdStopServer :call s:stopServer()
endif

augroup MdSlide
  autocmd FileType markdown :call s:init()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
