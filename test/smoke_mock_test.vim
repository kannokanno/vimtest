let s:testcase = vimtest#new('Smoke:モック機能') "{{{

function! s:testcase.startup()
  call vmock#clear()

  function! g:vimtest_test_func_one_args(one)
    return 1
  endfunction
endfunction

function! s:testcase.shutdown()
  delfunction g:vimtest_test_func_one_args
endfunction

function! s:testcase.success_case()
  call self.assert.equals(1, g:vimtest_test_func_one_args('hoge'))
  call vmock#mock('g:vimtest_test_func_one_args').with('hoge').return(100).once()
  call self.assert.equals(100, g:vimtest_test_func_one_args('hoge'))
endfunction

" このテストは必ず失敗する(失敗することが正しい)
function! s:testcase.always_failed()
  call self.assert.equals(1, g:vimtest_test_func_one_args('hoge'))
  call vmock#mock('g:vimtest_test_func_one_args').with('hoge').return(100).once()
  " expected once but actual 2 call
  call self.assert.equals(100, g:vimtest_test_func_one_args('hoge'))
endfunction
"}}}
