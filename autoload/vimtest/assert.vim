" FILE: vimtest#assert#assert.vim
" AUTHOR: kanno <akapanna@gmail.com>
" Last Change: 2012 Mar 31
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#assert#new()
  let assert = {
        \ '_progress': [],
        \ '_passed': [],
        \ '_failed': [],
        \ '_current_testcase': '',
        \ }

  function! assert.equals(...)
    let argc = len(a:000)
    if argc < 2
      throw printf('assertに渡す引数が少ないです:%s', string(a:000))
    endif
    let expected = a:1
    let actual = a:2

    if (empty(expected) && empty(actual))
          \ || expected ==# actual
      return self.success()
    else
      return self.failed(printf('%s', s:format('Failed asserting', string(expected), string(actual))))
    endif
  endfunction

  function! assert.notEquals(...)
    let argc = len(a:000)
    if argc < 2
      throw printf('assertに渡す引数が少ないです:%s', string(a:000))
    endif
    let expected = a:1
    let actual = a:2

    if (empty(expected) && empty(actual))
          \ || expected ==# actual
      return self.failed(s:format('Failed asserting not', string(expected), string(actual)))
    else
      return self.success()
    endif
  endfunction

  function! assert.true(...)
    if 1 == a:1
      return self.success()
    endif
    return self.failed(printf('Failed asserting expected 1 but was:%s', string(a:1)))
  endfunction

  function! assert.false(...)
    if 0 == a:1
      return self.success()
    endif
    return self.failed(printf('Failed asserting expected 0 but was:%s', string(a:1)))
  endfunction

  function! assert.success()
    call insert(self._passed, {})
    call add(self._progress, '.')
    return 1
  endfunction

  function! assert.failed(message)
    call s:insert(self._failed, self._current_testcase, a:message)
    call add(self._progress, 'F')
    return 0
  endfunction

  function! assert.error(message)
    call s:insert(self._failed, self._current_testcase, a:message)
    call add(self._progress, 'E')
    return 0
  endfunction

  return assert
endfunction

function! s:format(message, expected, actual)
  let message = a:message
  if !empty(message)
    let message = message . ' '
  endif
  return printf('%sexpected:<%s> but was:<%s>', message, a:expected, a:actual)
endfunction

function! s:insert(list, testcase, message)
  call insert(a:list, {
        \ 'testcase': a:testcase,
        \ 'message': a:message,
        \ })
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
