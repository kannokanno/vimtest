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

function! s:vimtest#reset()
  let s:vimtest.runners = []
endfunction

function! vimtest#new(name)
  let runner = {
        \ '_name': a:name,
        \ '_passed': [],
        \ '_failed': [],
        \ '_current_testcase': '',
        \ '_summary_on': 1,
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

  function! runner.assert(...)
    let argc = len(a:000)
    if argc < 2
      throw 'assertに渡す引数が少ないです'
    endif
    let expected = a:1
    let actual = a:2
    let message = argc == 3 ? a:3 . ':' : ''

    if (empty(expected) && empty(actual))
          \ || expected ==# actual
      call insert(self._passed, {})
      return 1
    else
      call self._insertFailed(printf('%s%s', message, s:format('Failed asserting', expected, actual)))
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
        let self._current_testcase = func
        call self.setup()
        call call(self[func], [], self)
        call self.teardown()
      endfor
    catch
      call self._insertFailed(printf('Excpetion:%s in %s', v:exception, v:throwpoint))
    finally
    endtry
    call self.shutdown()
    call self._result()
  endfunction

  function! runner._insertFailed(message)
    call insert(self._failed, {
          \ 'testcase': self._current_testcase,
          \ 'message': a:message,
          \ })
  endfunction

  function! runner._result()
    let failures = []
    let passed_count = len(self._passed)
    let failed_count = len(self._failed)
    if !empty(self._failed)
      echo printf("\n# %s", self._name)
      for i in range(failed_count)
        let f = self._failed[i]
        echo printf('  %d) %s', i+1, f.testcase)
        echo printf("      %s\n", f.message)
      endfor
    endif
    if self._summary_on
      call s:summary_message(passed_count, failed_count)
    endif
  endfunction

  call add(s:vimtest.runners, runner)
  return runner
endfunction

function! vimtest#run()
  for r in self.runners
    let r._summary_on = 0
    call r.run()
  endfor
  call self.result()
endfunction

function! s:vimtest.result()
  let total_passed_count = 0
  let total_failed_count = 0
  for r in self.runners
    let total_passed_count += len(r._passed)
    let total_failed_count += len(r._failed)
  endfor
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

let &cpo = s:save_cpo
unlet s:save_cpo
