function! vimtest#util#to_string(value)
  if type(a:value) ==# type('a')
    return a:value
  else
    return string(a:value)
  endif
endfunction
