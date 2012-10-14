" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#reset()
  unlet! s:vimtest
  let s:vimtest = s:initialize_instance()
endfunction

function! vimtest#run(path, type)
  try
    let config = vimtest#config#get()
    call extend(s:vimtest, s:parse_args(a:path, a:type))
    call s:source(s:vimtest.testfile)
    if !empty(s:vimtest.runners)
      call s:vimtest.outputter.init()
      for r in s:vimtest.runners
        call r._run()
      endfor
      let results = s:test_results()

      call s:vimtest.outputter.out(results)

      if config.show_summary_cmdline
        echo s:vimtest.outputter.online_summary(results)
      endif
    endif
  catch
    echoerr v:exception
  finally
    call vimtest#reset()
  endtry
endfunction

function! vimtest#new(...)
  let runner_name = len(a:000) > 0 && !empty(a:1) ? a:1 : 'No Name Test'
  let runner = vimtest#runner#new(runner_name)
  " NOTE: テスト失敗時に対象ファイル名を表示するために必要
  let runner.assert.result._filepath = s:vimtest.current_source_testpath
  call add(s:vimtest.runners, runner)
  return runner
endfunction

function! s:source(testpath)
  if isdirectory(a:testpath)
    for file in split(globpath(a:testpath, "**/*_test.vim"), "\n")
      call s:source(file)
    endfor
  else
    let product_codepath = vimtest#util#to_product_codepath(a:testpath)
    if !empty(product_codepath)
      silent! execute ':source ' . product_codepath
    endif

    " NOTE: 出力情報のためセットする。この値はvimtest#new()で使用される
    let s:vimtest.current_source_testpath = a:testpath
    silent! execute ':source ' . a:testpath
    let s:vimtest.current_source_testpath = ''
  endif
endfunction

function! s:parse_args(path, type)
  let info = {}
  let info.testfile = empty(a:path) ? expand('%') : a:path
  let info.outputter = vimtest#outputter#get(a:type)
  return info
endfunction

function! s:test_results()
  return map(s:vimtest.runners, 'v:val.assert.result')
endfunction

function! s:initialize_instance()
  return {
        \ 'runners'   : [],
        \ 'outputter' : '',
        \ 'testfile'  : '',
        \ 'current_source_testpath'  : '',
        \ }
endfunction

let s:vimtest = s:initialize_instance()

let &cpo = s:save_cpo
unlet s:save_cpo
