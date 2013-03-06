" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#message#summary(test_count, passed_count, failed_count)
  return printf("Test cases run: %d, Assertions: %d, Passes: %d, Failures: %d\n",
        \ a:test_count,
        \ a:passed_count + a:failed_count,
        \ a:passed_count,
        \ a:failed_count,
        \ )
endfunction

function! vimtest#message#failure_assert(expected, actual)
  let expected = vimtest#util#to_string(a:expected)
  let actual = vimtest#util#to_string(a:actual)
  return s:assert_failure_format(expected, actual)
endfunction

function! vimtest#message#failure_assert_not(expected, actual)
  let expected = vimtest#util#to_string(a:expected)
  let actual = vimtest#util#to_string(a:actual)
  return printf("Failed asserting not expected <%s> but was <%s>", expected, actual)
endfunction

function! vimtest#message#exception(message, throwpoint)
  return printf("Exception:%s\n   in %s", a:message, a:throwpoint)
endfunction

function! vimtest#message#not_enough_args(funcname, expected, actual)
  return printf('Not enough args for %s. expected %d but was %d', a:funcname, a:expected, a:actual)
endfunction

function! vimtest#message#invalid_bool_arg(value)
  let type = type(a:value)
  if type ==# type('') || type ==# type(1)
    return ''
  endif

  if type ==# type([])
    let type = 'list'
  elseif type ==# type({})
    let type = 'dict'
  endif
  return printf('Invalid arg<%s> type %s. valid type is string or num', string(a:value), type)
endfunction

" TODO test
function! vimtest#message#progress_line(status, testcase)
  let mark = a:status == 1 ? 'x' : ' '
  return printf(' [%s] %s', mark, a:testcase)
endfunction

function! s:assert_failure_format(expected, actual)
  let pattern  = "Failed asserting that two values are equal"
  let pattern .= "\n"
  let pattern .= "   - expected:%s"
  let pattern .= "\n"
  let pattern .= "   +   actual:%s"
  return printf(pattern, a:expected, a:actual)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
