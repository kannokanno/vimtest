" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#message#summary(passed_count, failed_count)
  return printf("\n\nTest cases run: %d, Passes: %d, Failures: %d\n",
        \ a:passed_count + a:failed_count,
        \ a:passed_count,
        \ a:failed_count,
        \ )
endfunction

function! vimtest#message#failure_assert(expected, actual)
  let expected = vimtest#util#to_string(a:expected)
  let actual = vimtest#util#to_string(a:actual)
  return printf("Failed asserting expected <%s> but was <%s>", expected, actual)
endfunction

function! vimtest#message#failure_assert_not(expected, actual)
  let expected = vimtest#util#to_string(a:expected)
  let actual = vimtest#util#to_string(a:actual)
  return printf("Failed asserting not expected <%s> but was <%s>", expected, actual)
endfunction

function! vimtest#message#exception(message, throwpoint)
  return printf("Excpetion:%s\n       in %s", a:message, a:throwpoint)
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

let &cpo = s:save_cpo
unlet s:save_cpo
