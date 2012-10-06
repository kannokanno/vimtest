function! s:add(x, y)
  return a:x + a:y
endfunction

function! s:subtract(x, y)
  return a:x - a:y
endfunction

let s:testcase = vimtest#new()
function! s:testcase.sum()
  let x = 1
  let y = 2
  call self.assert.equals(3, x + y)
endfunction

let s:testcase = vimtest#new('sample test')
function! s:testcase.sum()
  call self.assert.equals(3, s:add(1, 2))
endfunction
function! s:testcase.subtract()
  call self.assert.equals(2, s:subtract(4, 2))
  call self.assert.equals(-1, s:subtract(2, 3))
endfunction

let s:testcase = vimtest#new('another s:testcase')
function! s:testcase.sum()
  call self.assert.equals(3, s:add(1, s:subtract(4, 2)))
  call self.assert.equals(3, s:add(1, s:subtract(4, 2)))
endfunction

let s:testcase = vimtest#new('assert sample')
function! s:testcase.equals()
  " equasl is ==#
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
  " true is 1
  call self.assert.true(1)
  call self.assert.true('a' ==# 'a')
  call self.assert.true(empty([]))
endfunction

function! s:testcase.false()
  " false is 0
  call self.assert.false(0)
  call self.assert.false('a')
  call self.assert.false(empty([1]))
endfunction

let s:testcase = vimtest#new('sample failed message')
function! s:testcase.failed()
  call self.assert.equals(1, 2)
endfunction
function! s:testcase.error_one()
  call self.assert.equals(1, [)
endfunction
function! s:testcase.error_two()
  hoge
endfunction

let s:testcase = vimtest#new('prepare')
function! s:testcase.setup()
  " self.custom is dictionary
  let self.custom = {'expected': 3}
  function! self.custom.add()
    return 1 + 2
  endfunction
endfunction
function! s:testcase.sum()
  call self.assert.equals(self.custom.expected, self.custom.add())
endfunction

" prepare function
"  - startup
"  - setup
"  - teardown
"  - shutdown
let s:testcase = vimtest#new('prepare flow')
function! s:testcase.startup()
  echo 'startup'
endfunction
function! s:testcase.setup()
  echo '  setup'
endfunction
function! s:testcase.test_one()
  echo '   test one'
endfunction
function! s:testcase.test_two()
  echo '   test two'
endfunction
function! s:testcase.test_three()
  echo '   test three'
endfunction
function! s:testcase.teardown()
  echo '  teardown'
endfunction
function! s:testcase.shutdown()
  echo 'shutdown'
endfunction
