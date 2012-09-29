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
      throw vimtest#message#not_enough_args('assert', 2, len(a:000))
    endif
    let expected = a:1
    let actual = a:2

    try
      if (empty(expected) && empty(actual))
            \ || ((type(expected) ==# type(actual)) && (expected ==# actual))
        return self.success()
      else
        return self.failed(vimtest#message#failure_assert(expected, actual))
      endif
    catch
      call self.error(v:exception, v:throwpoint)
    endtry
  endfunction

  " TODO キャメルケースに違和感
  function! assert.notEquals(...)
    let argc = len(a:000)
    if argc < 2
      throw vimtest#message#not_enough_args('assert', 2, len(a:000))
    endif
    let expected = a:1
    let actual = a:2

    try
      if (empty(expected) && empty(actual))
            \ || expected ==# actual
        return self.failed(vimtest#message#failure_assert_not(expected, actual))
      else
        return self.success()
      endif
    catch
      call self.error(v:exception, v:throwpoint)
    endtry
  endfunction

  function! assert.true(...)
    return self.match(1, string(a:1))
  endfunction

  function! assert.false(...)
    return self.match(0, string(a:1))
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

  function! assert.error(exception, throwpoint)
    let message = vimtest#message#exception(a:exception, a:throwpoint)
    call s:insert(self._failed, self._current_testcase, message)
    call add(self._progress, 'E')
    return 0
  endfunction

  " TODO assert.equalsで置き換える
  function! assert.match(expected, arg)
    try
      if a:expected == a:arg
        return self.success()
      endif
      return self.failed(vimtest#message#failure_assert(expected, actual))
    catch
      call self.error(v:exception, v:throwpoint)
    endtry
  endfunction

  return assert
endfunction

function! s:insert(list, testcase, message)
  call insert(a:list, {
        \ 'testcase': a:testcase,
        \ 'message': a:message,
        \ })
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
