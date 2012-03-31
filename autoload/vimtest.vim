" FILE: vimtest.vim
" AUTHOR: kanno <akapanna@gmail.com>
" Last Change: 2012 Mar 31
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

if exists('s:vimtest')
  unlet s:vimtest
endif
let s:vimtest = {'runners': []}

function! vimtest#reset()
  let s:vimtest.runners = []
endfunction

function! vimtest#run()
  for r in s:vimtest.runners
    call r.run()
  endfor
  call s:vimtest.result()
  call vimtest#reset()
endfunction

function! vimtest#new(name)
  let runner = {
        \ '_name': a:name,
        \ 'assert': {
        \   '_progress': [],
        \   '_passed': [],
        \   '_failed': [],
        \   '_current_testcase': '',
        \ },
        \ 'custom': {},
        \ }
  function! runner.startup()
  endfunction
  function! runner.setup()
  endfunction
  function! runner.teardown()
  endfunction
  function! runner.shutdown()
  endfunction

  function! runner.assert.equals(...)
    let expected = a:1
    let actual = a:2
    if vimtest#assert#equals(expected, actual)
      call insert(self._passed, {})
      call add(self._progress, '.')
      return 1
    else
      call s:insert(self.failed, self._current_testcase, printf('%s', s:format('Failed asserting', expected, actual)))
      call add(self._progress, 'F')
      return 0
    endif
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
        call call(self[func], [], self)
        call self.teardown()
      endfor
    catch
      call s:insert(self.failed, self._current_testcase, printf('Excpetion:%s in %s', v:exception, v:throwpoint))
      call add(self.assert._progress, 'E')
    finally
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

function! s:vimtest.result()
  let total_passed_count = 0
  let total_failed_count = 0
  let failed_messages = []
  for r in s:vimtest.runners
    let total_passed_count += len(r.assert._passed)
    let total_failed_count += len(r.assert._failed)
    call add(failed_messages, r._result())
    for p in r.assert._progress
      echon p
    endfor
  endfor
  echo join(failed_messages, "\n")
  call s:summary_message(total_passed_count, total_failed_count)
endfunction

function! s:summary_message(passed_count, failed_count)
  if a:failed_count != 0
    echohl FailMsg | echo 'FAILURES!' | echohl FailMsg
  endif
  echo printf("Test cases run: %d, Passes: %d, Failures: %d\n",
        \ a:passed_count + a:failed_count,
        \ a:passed_count,
        \ a:failed_count,
        \ )
endfunction

function! s:format(message, expected, actual)
  let message = a:message
  if !empty(message)
    let message = message . ' '
  endif
  return printf('%sexpected:<%s> but was:<%s>', message, a:expected, a:actual)
endfunction

function! s:.insert(list, testcase, message)
  call insert(a:list, {
        \ 'testcase': a:testcase,
        \ 'message': a:message,
        \ })
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
