""""""""""""""""""
" some test target
function! s:create_target()
  let target = {}
  function! target.something(num)
    return a:num * 10
  endfunction
  return target
endfunction
""""""""""""""""""

let s:testcase = vimtest#new('custom property')
let s:testcase.target = s:create_target() " custom property

function! s:testcase.test_something1()
  call self.assert.equals(100, self.target.something(10))
endfunction

function! s:testcase.test_something2()
  call self.assert.equals(0, self.target.something(0))
endfunction
