let s:testcase = vimtest#new('runner_name')

function! s:testcase.default_is_filename()
  let expected = expand('%:t')
  call self.assert.equals(expected, vimtest#new()._name)
  call self.assert.equals(expected, vimtest#new('')._name)
endfunction

function! s:testcase.specified()
  call self.assert.equals('hoge', vimtest#new('hoge')._name)
  call self.assert.equals('ほげ', vimtest#new('ほげ')._name)
endfunction
