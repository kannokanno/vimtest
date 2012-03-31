function! s:_assert(expected, actual, bool)
  try
    let expected = a:expected
    let actual = a:actual
    if (expected == actual) == a:bool
      echon '.'
    else
      echo printf('NG:expected %s but was %s', expected, actual)
      echo ''
    endif
  catch
    echo printf('%s in %s', v:exception, v:throwpoint) 
  endtry
endfunction
function! s:assert(expected, actual)
  call s:_assert(a:expected, a:actual, 1)
endfunction
function! s:assertNot(expected, actual)
  call s:_assert(a:expected, a:actual, 0)
endfunction

" ---------
let s:_test = vimtest#new('new test')
call s:assert(1, s:_test.assert(2, 1 + 1))
call s:assert(1, s:_test.assert("a", "a"))
call s:assert(1, s:_test.assert("あ", "あ"))
call s:assert(0, s:_test.assert(1, 1 + 1))
call s:assert(0, s:_test.assert("", 1))
call s:assert(0, s:_test.assert(1, ""))
unlet s:_test

" ---------
let s:_test = vimtest#new('new test')
call s:assert('new test', s:_test._name)
call s:assertNot('hoge', s:_test._name)
unlet s:_test

" ---------
call vimtest#reset()
let s:_test = vimtest#new('new test')
function! s:_test.sum()  
  call self.assert(1, 1 + 0) " passed
  call self.assert(2, 1 + 1) " passed
  call self.assert(1, 1 + 2) " failed
endfunction 
call s:_test.run() " show failed message
call s:assert(3, len(s:_test._passed) + len(s:_test._failed))
call s:assert(2, len(s:_test._passed))
call s:assert(1, len(s:_test._failed))
unlet s:_test

" ---------
call vimtest#reset()
let s:_test = vimtest#new('ex catch test')
function! s:_test.sum()  
  call self.assert(1, 1 + 0) " passed
  call self.assert(1, a) " inner exception
endfunction 
call s:_test.run() " show failed message
call s:assert(2, len(s:_test._passed) + len(s:_test._failed))
call s:assert(1, len(s:_test._passed))
call s:assert(1, len(s:_test._failed))
unlet s:_test

" ---------
call vimtest#reset()
let s:_test = vimtest#new('multiple test')
function! s:_test.something_one()  
  call self.assert(1, 1 + 0) " passed
  call self.assert(1, 1 + 2) " failed
endfunction 
function! s:_test.something_two()  
  call self.assert(1, 1 + 0) " passed
  call self.assert(1, 1 + 0) " passed
  call self.assert(1, 1 + 2) " failed
endfunction 
call s:_test.run() " show failed message
call s:assert(5, len(s:_test._passed) + len(s:_test._failed))
call s:assert(3, len(s:_test._passed))
call s:assert(2, len(s:_test._failed))
unlet s:_test

" ---------
call vimtest#reset()
let s:_test_a = vimtest#new('multiple conetxt a')
function! s:_test_a.setup()  
  let self.custom = {'expected': 1}
endfunction
function! s:_test_a.one()  
  call self.assert(self.custom.expected, 1 + 0) " passed
  call self.assert(self.custom.expected, 1 + 2) " failed
endfunction 
function! s:_test_a.two()  
  call self.assert(1, 1 + 0) " passed
  call self.assert(1, 1 + 0) " passed
  call self.assert(1, 1 + 2) " failed
endfunction 

let s:_test_b = vimtest#new('multiple conetxt b')
function! s:_test_b.one()  
  call self.assert(1, 1 + 0) " passed
endfunction 
function! s:_test_b.two()  
  call self.assert(1, 1 + 0) " passed
  call self.assert(1, 1 + 1, 'メッセージ確認') " failed
endfunction 
call vimtest#run() " show failed message

call s:assert(8, 
      \ len(s:_test_a._passed) +
      \ len(s:_test_a._failed) +
      \ len(s:_test_b._passed) +
      \ len(s:_test_b._failed)
      \ )
call s:assert(3, len(s:_test_a._passed))
call s:assert(2, len(s:_test_a._failed))
call s:assert(2, len(s:_test_b._passed))
call s:assert(1, len(s:_test_b._failed))
unlet s:_test_a
unlet s:_test_b


" ---------
call vimtest#reset()
let s:_test = vimtest#new('workflow test')
function! s:_test.startup()  
  echo 'startup'
endfunction
function! s:_test.setup()  
  echo 'setup'
  let self.custom = {'value': 'custom value 1'}
endfunction
function! s:_test.teardown()  
  echo 'teardown'
endfunction
function! s:_test.shutdown()  
  echo 'shutdown'
endfunction
function! s:_test.one()  
  echo self.custom.value
endfunction 
function! s:_test.two()  
  echo self.custom.value
endfunction 
call vimtest#run()
