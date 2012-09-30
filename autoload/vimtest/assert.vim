" FILE: vimtest#assert#assert.vim
" AUTHOR: kanno <akapanna@gmail.com>
" Last Change: 2012 Mar 31
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

" TODO assert本体と結果の保持ロジックが混在している
" TODO 重複部分のリファクタ
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

  function! assert.not_equals(...)
    let argc = len(a:000)
    if argc < 2
      throw vimtest#message#not_enough_args('assert', 2, len(a:000))
    endif
    let expected = a:1
    let actual = a:2

    try
      if (empty(expected) && empty(actual))
            \ || ((type(expected) ==# type(actual)) && (expected ==# actual))
        return self.failed(vimtest#message#failure_assert_not(expected, actual))
      else
        return self.success()
      endif
    catch
      call self.error(v:exception, v:throwpoint)
    endtry
  endfunction

  function! assert.true(...)
    let argc = len(a:000)
    if argc < 1
      throw vimtest#message#not_enough_args('assert', 1, len(a:000))
    endif
    let arg = a:1
    let type = type(arg)
    if type ==# type([]) || type ==# type({})
      throw vimtest#message#invalid_bool_arg(arg)
    endif
    let bool = arg ? 1 : 0
    return self.equals(1, bool)
  endfunction

  function! assert.false(...)
    let argc = len(a:000)
    if argc < 1
      throw vimtest#message#not_enough_args('assert', 1, len(a:000))
    endif
    let arg = a:1
    let type = type(arg)
    if type ==# type([]) || type ==# type({})
      throw vimtest#message#invalid_bool_arg(arg)
    endif
    let bool = arg ? 1 : 0
    return self.equals(0, bool)
  endfunction

  function! assert.success()
    call insert(self._passed, {})
    call add(self._progress, '.')
    return 1
  endfunction

  " TODO リファクタ過程
  function! assert.failure(message)
    call s:insert(self._failed, self._current_testcase, a:message)
    call add(self._progress, 'F')
    return 0
  endfunction

  function! assert.failed(message)
    return self.falure(a:message)
  endfunction

  function! assert.error(exception, throwpoint)
    let message = vimtest#message#exception(a:exception, a:throwpoint)
    call s:insert(self._failed, self._current_testcase, message)
    call add(self._progress, 'E')
    return 0
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
