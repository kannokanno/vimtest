" FILE: vimtest.vim
" AUTHOR: kanno <akapanna@gmail.com>
" Last Change: 2012 Mar 31
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

if exists('s:vimtest')
  unlet s:vimtest
endif

function! s:initialize_instance()
  return {
        \ 'runners'   : [],
        \ 'outputter' : '',
        \ 'testfile'  : '',
        \ }
endfunction
let s:vimtest = s:initialize_instance()

function! s:parse_args(path, type)
  let info = {}
  let info.testfile = empty(a:path) ? expand('%') : a:path
  let info.outputter = s:get_outputter(a:type)
  return info
endfunction

function! s:get_outputter(type)
  if a:type ==? 'buffer'
    return vimtest#outputter#buffer#new()
  elseif a:type ==? 'string'
    return vimtest#outputter#string#new()
  elseif a:type ==? 'stdout'
    return vimtest#outputter#stdout#new()
  else
    return vimtest#outputter#buffer#new()
  endif
endfunction

function! vimtest#reset()
  let s:vimtest = s:initialize_instance()
endfunction

function! vimtest#run(path, type)
  try
    call extend(s:vimtest, s:parse_args(a:path, a:type))
    " TODO どんなソースもsourceしちゃう
    silent! execute ':source ' . s:vimtest.testfile
    if !empty(s:vimtest.runners)
      call s:vimtest.outputter.init()
      for r in s:vimtest.runners
        call r.run()
      endfor
      call s:vimtest.outputter.out(s:vimtest.runners)
    endif
  catch
    echoerr v:errmsg
  finally
    call vimtest#reset()
  endtry
endfunction

function! vimtest#new(...)
  let name = len(a:000) > 0 ? a:1 : expand('%:t')
  let runner = {
        \ '_name'  : name,
        \ 'assert' : vimtest#assert#new(),
        \ 'custom' : {},
        \ }
  function! runner.startup()
  endfunction
  function! runner.setup()
  endfunction
  function! runner.teardown()
  endfunction
  function! runner.shutdown()
  endfunction

  function! runner.run(...)
    try
      " TODO dirty
      let pattern = join([
            \ 'type(self[v:val]) == type(function("tr"))',
            \ 'v:val != "run"',
            \ 'v:val !~ "^_"',
            \ 'v:val !~ "^assert"',
            \ 'v:val !~ "^startup"',
            \ 'v:val !~ "^setup"',
            \ 'v:val !~ "^teardown"',
            \ 'v:val !~ "^shutdown"',
            \ ], '&&')
      call self.startup()
      for func in filter(keys(self), pattern)
        let self.assert._current_testcase = func
        call self.setup()
        try
          call call(self[func], [], self)
        catch
          call self.assert.error(v:exception, v:throwpoint)
        endtry
        call self.teardown()
      endfor
    catch
      call self.assert.error(v:exception, v:throwpoint)
    endtry
    call self.shutdown()
    call self._result()
  endfunction

  function! runner._result()
    let failed_messages = []
    if !empty(self.assert._failed)
      call add(failed_messages, printf("\n# %s", self._name))
      for i in range(len(self.assert._failed))
        let f = self.assert._failed[i]
        call add(failed_messages, printf("  %d) %s", i+1, f.testcase))
        call add(failed_messages, printf("      %s\n", f.message))
      endfor
    endif
    return join(failed_messages, "\n")
  endfunction

  call add(s:vimtest.runners, runner)
  return runner
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
