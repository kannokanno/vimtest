function! s:assert(bool)
  if a:bool
    echon '.'
  else
    echon 'F'
  endif
endfunction

function! s:assertNot(bool)
  call s:assert(!a:bool)
endfunction

" equals
call s:assert(vimtest#assert#equals(1, 1))
call s:assertNot(vimtest#assert#equals(1, 0))
call s:assert(vimtest#assert#equals('a', 'a'))
call s:assertNot(vimtest#assert#equals('a', 'A'))
call s:assertNot(vimtest#assert#equals('a', 'b'))
call s:assert(vimtest#assert#equals([], []))
call s:assert(vimtest#assert#equals([1], [1]))
call s:assert(vimtest#assert#equals(['a'], ['a']))
call s:assertNot(vimtest#assert#equals(['a'], ['b']))

" notEquals
call s:assertNot(vimtest#assert#notEquals(1, 1))
call s:assert(vimtest#assert#notEquals(1, 0))
call s:assertNot(vimtest#assert#notEquals('a', 'a'))
call s:assert(vimtest#assert#notEquals('a', 'A'))
call s:assert(vimtest#assert#notEquals('a', 'b'))
call s:assertNot(vimtest#assert#notEquals([], []))
call s:assertNot(vimtest#assert#notEquals([1], [1]))
call s:assertNot(vimtest#assert#notEquals(['a'], ['a']))
call s:assert(vimtest#assert#notEquals(['a'], ['b']))

" true
call s:assert(vimtest#assert#true(1))
call s:assertNot(vimtest#assert#true(0))
call s:assertNot(vimtest#assert#true('a'))
call s:assertNot(vimtest#assert#true(1 == 0))
call s:assertNot(vimtest#assert#true('a' == 'b'))

" false
call s:assertNot(vimtest#assert#false(1))
call s:assert(vimtest#assert#false(0))
call s:assert(vimtest#assert#false('a'))
call s:assert(vimtest#assert#false(1 == 0))
call s:assert(vimtest#assert#false('a' == 'b'))

