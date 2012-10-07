let s:testcase = vimtest#new('name')

function! s:testcase.construct_arg_is_runner_name()
  call self.assert.equals('hoge', vimtest#runner#new('hoge')._name)
  call self.assert.equals('ほげ', vimtest#runner#new('ほげ')._name)
endfunction


let s:testcase = vimtest#new('get_testcases')

function! s:testcase.dummy_test1()
  " dummy
endfunction
function! s:testcase._dummy_test2()
  " dummy
endfunction
function! s:testcase.dummy_test3()
  " dummy
endfunction
function! s:testcase.run()
  " dummy
endfunction
function! s:testcase.startup1()
  " dummy
endfunction
function! s:testcase.setup1()
  " dummy
endfunction
function! s:testcase.teardown1()
  " dummy
endfunction
function! s:testcase.shutdown1()
  " dummy
endfunction

function! s:testcase.testcase_names()
  let expected = [
        \'dummy_test1',
        \'dummy_test3',
        \'testcase_names',
        \'run',
        \'startup1',
        \'setup1',
        \'teardown1',
        \'shutdown1',
        \]
  " 順序無視
  call self.assert.equals(sort(expected), sort(self._get_testcases()))
endfunction
