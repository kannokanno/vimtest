" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

" TODO 重複部分のリファクタ
function! vimtest#assert#new(name)
  let assert = {
        \ 'result' : vimtest#result#new(a:name),
        \ }

  function! assert.set_current_testcase(func_name)
    let self.result._current_testcase = a:func_name
  endfunction

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
        return self.fail(vimtest#message#failure_assert(expected, actual))
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
        return self.fail(vimtest#message#failure_assert_not(expected, actual))
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

  " shortcut
  function! assert.success()
    call self.result.success()
    return 1
  endfunction

  " shortcut
  function! assert.fail(...)
    call self.result.fail(a:1)
    return 0
  endfunction

  " shortcut
  function! assert.error(exception, throwpoint)
    call self.result.error(a:exception, a:throwpoint)
    return 0
  endfunction

  return assert
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
