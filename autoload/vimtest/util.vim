function! vimtest#util#to_string(value)
  if type(a:value) ==# type('a')
    return a:value
  else
    return string(a:value)
  endif
endfunction

function! vimtest#util#to_product_codepath(testpath)
  let path = a:testpath
  " TODO /プラグイン名/test/ => /pluginname/
  let path = substitute(path, '/test/', '/', '')
  return substitute(path, '_test.vim', '.vim', '')
endfunction

function! vimtest#util#autocmd_str(event, cmdarg)
  if empty(a:event) || empty(a:cmdarg)
    return ''
  endif
  return printf('autocmd BufWritePost %s VimTest %s', a:event, a:cmdarg)
endfunction
