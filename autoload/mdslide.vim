" Generate Web based slide with Markdown and reveal.js
" Author: mas9612 <mas9612@gmail.com>
" License: This file is placed in the public domain.

let s:save_cpo = &cpo
set cpo&vim

let s:base_dir = expand('<sfile>:p:h:h')

function! mdslide#openBrowser()
  if !exists('g:mdslide_open_browser_cmd')
    echohl ErrorMsg
    echo 'To open browser, please set g:mdslide_open_browser_cmd variable.'
    echohl None
  else
    let html_path = s:base_dir . '/view/'
    call system(g:mdslide_open_browser_cmd . ' http://localhost:8000' . html_path)
  endif
endfunction

function! mdslide#startServer()
  let pid_file = s:base_dir . '/plugin/mdslide_server.pid'
  if filereadable(pid_file)
    echo 'Local server is already running.'
  else
    let script_path = s:base_dir . '/autoload/server.py ' . s:base_dir
    call system(script_path . ' &')
  endif
endfunction

function! mdslide#stopServer()
  let pid_file = s:base_dir . '/plugin/mdslide_server.pid'
  if filereadable(pid_file)
    let lines = readfile(pid_file)
    let pid = lines[0]

    if pid !=? ""
      let command = "kill " . pid
      call system(command)
    endif
  endif

  call delete(pid_file)
endfunction

function! mdslide#restartServer()
  call mdslide#stopServer()
  call mdslide#startServer()
endfunction

function! mdslide#getServerStatus()
  let pid_file = s:base_dir . '/plugin/mdslide_server.pid'
  if filereadable(pid_file)
    let lines = readfile(pid_file)
    let pid = lines[0]

    echo 'Server is running. PID: ' . pid
  else
    echo 'Server is not running.'
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

    " convert relative image path to absolute
    let imagepath = matchstr(line, '\v!\[.+\]\(\zs[^ "]+\ze.*\)')
    let origin_imagepath = imagepath
    if imagepath !=# ''
      " is relative path
      if imagepath[0] !=# '/'
        " convert to absolute path
        if imagepath[0:1] ==# '~/'
          let homedir = expand('~')
          let imagepath = substitute(imagepath, '\V~', homedir, '')
        elseif imagepath[0:1] ==# './'
          let curdir = expand('%:p:h')
          let imagepath = substitute(imagepath, '\V.', curdir, '')
        elseif imagepath[0:2] ==# '../'
          let curdir = expand('%:p:h')
          let imagepath = curdir . '/' . imagepath
        else
          let curdir = expand('%:p:h')
          let imagepath = curdir . '/' . imagepath
        endif
      endif
      let line = substitute(line, '\V(\zs' . origin_imagepath . '\ze)', imagepath, '')
    endif

    call add(escaped, line)
  endfor

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
