let s:testcase = vimtest#new()

function! s:testcase.outtpuer_typenames()
  return ['buffer', 'string', 'stdout']
endfunction

function! s:testcase.get_outputter_default_is_buffer()
  call self.assert.equals('buffer', vimtest#outputter#get('')._name)
  call self.assert.equals('buffer', vimtest#outputter#get('hoge')._name)
endfunction

function! s:testcase.get_outputter_by_typename()
  for typename in self.outtpuer_typenames()
    call self.assert.equals(typename, vimtest#outputter#get(typename)._name)
  endfor
endfunction

