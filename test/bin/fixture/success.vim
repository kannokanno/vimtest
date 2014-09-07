let s:test = vimtest#new()
function! s:test.success()
  call self.assert.success()
endfunction

