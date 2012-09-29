let s:testcase = vimtest#new()
function! s:testcase.to_string()
  call self.assert.equals(string(10), vimtest#util#to_string(10))
  call self.assert.equals('hoge', vimtest#util#to_string('hoge'))
  call self.assert.equals(string([1,2,'a']), vimtest#util#to_string([1,2,'a']))
  call self.assert.equals(string({'a':1, 2:'b'}), vimtest#util#to_string({'a':1, 2:'b'}))
endfunction
