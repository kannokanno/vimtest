function! vimtest#config#get()
  let default = {
        \ 'autotest_watch_patterns': [],
        \ 'autotest_testpath': '',
        \ }
  return extend(default, g:vimtest_config)
endfunction
