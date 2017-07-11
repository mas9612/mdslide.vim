" Generate Web based slide with Markdown and reveal.js
" Author: mas9612 <mas9612@gmail.com>
" License: This file is placed in the public domain.

let s:save_cpo = &cpo
set cpo&vim

function! mdslide#openBrowser()
  if !exists('g:mdslide_open_browser_cmd')
    echohl ErrorMsg
    echo 'To open browser, please set g:mdslide_open_browser_cmd variable.'
    echohl None
  else
    call system(g:mdslide_open_browser_cmd . ' http://localhost:8000/')
  endif
endfunction

let s:base_dir = expand('<sfile>:p:h:h')
function! mdslide#startServer()
  let script_path = s:base_dir . '/autoload/server.py'
  let document_root = s:base_dir . '/view/'
  call system(script_path . ' ' . document_root . ' &')
endfunction

function! mdslide#stopServer()
  let pid = system("ps aux | grep \"[s]erver.py\" | awk '{print $2}'")

  if pid !=? ""
    let command = "kill " . pid
    call system(command)
  endif
endfunction

function! mdslide#refresh_content()
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
  let output_path = s:base_dir . '/view/js/mdslide/contents.js'

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

let &cpo = s:save_cpo
unlet s:save_cpo
