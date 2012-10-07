let s:testcase = vimtest#new() " default testcase name = current filename
function! s:testcase.test1()
  let expected = 1
  let actual = 1
  call self.assert.equals(expected, actual)
endfunction

function! s:testcase.test2()
  call self.assert.equals(1, 1)
endfunction

function! s:testcase.test3()
  call self.assert.equals([1,2], [1,2])
endfunction

" execute command
" :VimTest
