" FILE: vimtest#assert#assert.vim
" AUTHOR: kanno <akapanna@gmail.com>
" Last Change: 2012 Mar 31
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#assert#equals(...)
  let argc = len(a:000)
  if argc < 2
    throw printf('assertに渡す引数が少ないです:%s', string(a:000))
  endif
  let expected = a:1
  let actual = a:2

  if (empty(expected) && empty(actual))
        \ || expected ==# actual
    return 1
  else
    return 0
  endif
endfunction

function! vimtest#assert#notEquals(...)
  return !vimtest#assert#equals(a:1, a:2)
endfunction

function! vimtest#assert#true(...)
  return 1 == a:1
endfunction

function! vimtest#assert#false(...)
  return !vimtest#assert#true(a:1)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
