let s:test = vimtest#new()
function! s:test.fail()
  call self.assert.fail()
endfunction

