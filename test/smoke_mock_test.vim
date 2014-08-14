" vmockが入っている場合のみテストする "{{{
function! DummyForVMock()
endfunction
try
  call vmock#mock('DummyForVMock')
  let s:testcase = vimtest#new('Smoke:モック機能')
catch /E117.*/
  let s:testcase = {}
endtry

function! s:testcase.startup()
  function! VimTestTestFunc(one)
    return 1
  endfunction
endfunction

function! s:testcase.shutdown()
  delfunction VimTestTestFunc
endfunction

function! s:testcase.success_case()
  call self.assert.equals(1, VimTestTestFunc('hoge'))
  call vmock#mock('VimTestTestFunc').with('hoge').return(100).once()
  call self.assert.equals(100, VimTestTestFunc('hoge'))
endfunction

" このテストは必ず失敗する(失敗することが正しい)
function! s:testcase.always_failed()
  call self.assert.equals(1, VimTestTestFunc('hoge'))
  call vmock#mock('VimTestTestFunc').with('hoge').return(100).once()
  " expected once but actual 2 call
  call self.assert.equals(100, VimTestTestFunc('hoge'))
endfunction
"}}}
