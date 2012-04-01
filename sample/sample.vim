function! s:add(x, y)
  return a:x + a:y
endfunction

function! s:subtract(x, y)
  return a:x - a:y
endfunction

let testcase = vimtest#new()
function! testcase.sum()
  let x = 1
  let y = 2
  call self.assert.equals(3, x + y)
endfunction

let testcase = vimtest#new('sample test')
function! testcase.sum()
  call self.assert.equals(3, s:add(1, 2))
endfunction
function! testcase.subtract()
  call self.assert.equals(2, s:subtract(4, 2))
  call self.assert.equals(-1, s:subtract(2, 3))
endfunction

let testcase = vimtest#new('another testcase')
function! testcase.sum()
  call self.assert.equals(3, s:add(1, s:subtract(4, 2)))
  call self.assert.equals(3, s:add(1, s:subtract(4, 2)))
endfunction

let testcase = vimtest#new('assert sample')
function! testcase.equals()
  " equasl is ==#
  call self.assert.equals(3, 3)
  call self.assert.equals('a', 'a')
  call self.assert.equals([], [])
  call self.assert.equals([1], [1])
  call self.assert.equals(['a', 'b'], ['a', 'b'])
  call self.assert.equals({}, {})
  call self.assert.equals({'a':1}, {'a':1})
endfunction

function! testcase.notEquals()
  call self.assert.notEquals('a', 'A')
  call self.assert.notEquals(['b', 'a'], ['a', 'b'])
endfunction

function! testcase.true()
  " true is 1
  call self.assert.true(1)
  call self.assert.true('a' ==# 'a')
  call self.assert.true(empty([]))
endfunction

function! testcase.false()
  " false is 0
  call self.assert.false(0)
  call self.assert.false('a')
  call self.assert.false(empty([1]))
endfunction

let testcase = vimtest#new('sample failed message')
function! testcase.failed()
  call self.assert.equals(1, 2)
endfunction
function! testcase.error_one()
  call self.assert.equals(1, [])
endfunction
function! testcase.error_two()
  hoge
endfunction

let testcase = vimtest#new('prepare')
function! testcase.setup()
  " self.custom is dictionary
  let self.custom = {'expected': 3}
  function! self.custom.add()
    return 1 + 2
  endfunction
endfunction
function! testcase.sum()
  call self.assert.equals(self.custom.expected, self.custom.add())
endfunction

" prepare function
"  - startup
"  - setup
"  - teardown
"  - shutdown
let testcase = vimtest#new('prepare flow')
function! testcase.startup()
  echo 'startup'
endfunction
function! testcase.setup()
  echo '  setup'
endfunction
function! testcase.test_one()
  echo '   test one'
endfunction
function! testcase.test_two()
  echo '   test two'
endfunction
function! testcase.test_three()
  echo '   test three'
endfunction
function! testcase.teardown()
  echo '  teardown'
endfunction
function! testcase.shutdown()
  echo 'shutdown'
  echo ''
endfunction

call vimtest#run()
