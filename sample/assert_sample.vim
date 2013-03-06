let s:testcase = vimtest#new('assert sample')
function! s:testcase.equals()
  call self.assert.equals(3, 3)
  call self.assert.equals('a', 'a')
  call self.assert.equals([], [])
  call self.assert.equals([1], [1])
  call self.assert.equals(['a', 'b'], ['a', 'b'])
  call self.assert.equals({}, {})
  call self.assert.equals({'a':1}, {'a':1})
endfunction

function! s:testcase.not_equals()
  call self.assert.not_equals('a', 'A')
  call self.assert.not_equals(['b', 'a'], ['a', 'b'])
endfunction

function! s:testcase.true()
  call self.assert.true(1)
  call self.assert.true(-1)
  call self.assert.true('1')
  call self.assert.true('1a')
  call self.assert.true('a' ==# 'a')
  call self.assert.true(empty([]))
endfunction

function! s:testcase.false()
  call self.assert.false(0)
  call self.assert.false('a')
  call self.assert.false('a1')
  call self.assert.false(empty([1]))
endfunction

function! s:testcase.exception()
  call self.assert.throw('E492')
  hoge
endfunction

function! s:testcase.exception_message()
  call self.assert.throw('something wrong')
  throw 'something wrong'
endfunction
