let s:testcase = vimtest#new('name')

function! s:testcase.construct_arg_is_runner_name()
  call self.assert.equals('hoge', vimtest#runner#new('hoge')._name)
  call self.assert.equals('ほげ', vimtest#runner#new('ほげ')._name)
endfunction


let s:testcase = vimtest#new('get_testcases')

function! s:testcase.dummy_test1()
  " dummy
endfunction
function! s:testcase.dummy_test2()
  " dummy
endfunction

function! s:testcase.testcase_names()
  let expected = [
        \'dummy_test1',
        \'dummy_test2',
        \'testcase_names',
        \]
  call self.assert.equals(expected, self._get_testcases())
endfunction
