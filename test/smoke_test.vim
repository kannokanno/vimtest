let s:testcase = vimtest#new('10:正常系')

function! s:testcase.test10_1()
  call self.assert.equals(1, 1)
  call self.assert.equals(2, 2)
endfunction

function! s:testcase.test10_2()
  call self.assert.equals(1, 1)
  call self.assert.equals(2, 2)
endfunction

let s:testcase = vimtest#new('11:正常系 - setupなどのフックを利用')

function! s:testcase.startup()
  echo 'startup'
endfunction

function! s:testcase.setup()
  echo 'setup'
  let self.custom = {'value': 'custom value1'}
endfunction

function! s:testcase.teardown()
  echo 'teardown'
endfunction

function! s:testcase.shutdown()
  echo 'shutdown'
endfunction

function! s:testcase.one()
  call self.assert.equals('custom value1', self.custom.value)
endfunction 
function! s:testcase.two()
  call self.assert.not_equals('invalid value', self.custom.value)
endfunction 

let s:testcase = vimtest#new('20:異常系 - 内部例外が発生しても正常に失敗メッセージが生成される')

function! s:testcase.when_exception()
  call self.assert.equals(1, 1) " passed
  call self.assert.equals(1, a) " inner exception
  call self.assert.equals(1, 0) " not execute
endfunction

