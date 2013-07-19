function! vimtest#util#to_string(value)
  if type(a:value) ==# type('a')
    return a:value
  else
    return string(a:value)
  endif
endfunction

function! vimtest#util#to_product_codepath(testpath)
  let path = a:testpath
  let path = substitute(path, '/test/', '/', '')
  let product_path = substitute(path, '_test.vim', '.vim', '')
  return path ==# product_path ? '' : product_path
endfunction

function! vimtest#util#autocmd_str(event,cmdarg)
  if empty(a:event) || empty(a:cmdarg)
    return ''
  endif
  return printf('autocmd BufWritePost %s call vimtest#config#get().autotest_cmd("%s")', a:event, a:cmdarg)
endfunction

function! vimtest#util#augroup()
  let config = vimtest#config#get()
  augroup __VimTest__
    autocmd!
    for pattern in config.autotest_watch_patterns
      execute vimtest#util#autocmd_str(pattern, config.autotest_testpath)
    endfor
  augroup END
endfunction

function! vimtest#util#get_error_id(message)
  return matchstr(a:message, 'Vim\%((\a\+)\)\=:\zsE\d*\ze:')
endfunction

function! vimtest#util#settings()
  call vimtest#util#augroup()
endfunction

function! vimtest#util#safety_call(funcname)
  if type(a:funcname) ==# type('')
    try
      call call(a:funcname, [])
    catch /^Vim(\a\+):E117/
      " do nothing
    endtry
  endif
endfunction

