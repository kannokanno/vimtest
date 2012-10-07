" FILE: vimtest.vim
" AUTHOR: kanno <akapanna@gmail.com>
" Last Change: 2012 Mar 31
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#reset()
  unlet! s:vimtest
  let s:vimtest = s:initialize_instance()
endfunction

function! vimtest#run(path, type)
  try
    call extend(s:vimtest, s:parse_args(a:path, a:type))
    if isdirectory(s:vimtest.testfile)
      " TODO v0.0.3 feature
      echohl ErrorMsg | echo 'ディレクトリを指定しての実行は未実装です' | echohl None
      call vimtest#reset()
      return
    endif

    " TODO どんなソースもsourceしちゃう:命名規則に沿ったファイルに絞ってsource
    silent! execute ':source ' . s:vimtest.testfile
    if !empty(s:vimtest.runners)
      call s:vimtest.outputter.init()
      for r in s:vimtest.runners
        call r._run()
      endfor
      call s:vimtest.outputter.out(s:vimtest.runners)
    endif
  catch
    echoerr v:exception
  finally
    call vimtest#reset()
  endtry
endfunction

function! vimtest#new(...)
  let runner_name = len(a:000) > 0 && !empty(a:1) ? a:1 : expand('%:t')
  let runner = vimtest#runner#new(runner_name)
  call add(s:vimtest.runners, runner)
  return runner
endfunction

function! s:parse_args(path, type)
  let info = {}
  let info.testfile = empty(a:path) ? expand('%') : a:path
  let info.outputter = vimtest#outputter#get(a:type)
  return info
endfunction

function! s:initialize_instance()
  return {
        \ 'runners'   : [],
        \ 'outputter' : '',
        \ 'testfile'  : '',
        \ }
endfunction

let s:vimtest = s:initialize_instance()

let &cpo = s:save_cpo
unlet s:save_cpo
