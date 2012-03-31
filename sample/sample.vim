function! s:add(x, y)
  return a:x + a:y
endfunction

function! s:subtract(x, y)
  return a:x - a:y
endfunction

let testcase = vimtest#new('四則演算')
function! testcase.sum()
  call self.assert.equals(3, s:add(1, 2))
  call self.assert.equals(3, s:add(2, 2))
endfunction
function! testcase.subtract()
  call self.assert.equals(2, s:subtract(4, 2))
  call self.assert.equals(-1, s:subtract(2, 3))
endfunction

let testcase = vimtest#new('組み合わせ')
function! testcase.sum()
  call self.assert.equals(3, s:add(1, s:subtract(4, 2)))
  call self.assert.equals(4, s:add(1, s:subtract(4, 2)))
  call self.assert.equals(3, s:add(1, s:subtract(4, 2)))
endfunction

call vimtest#run()
