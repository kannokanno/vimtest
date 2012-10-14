function! vimtest#config#get()
  let default = {
        \ 'outputter': 'buffer',
        \ 'autotest_watch_patterns': [],
        \ 'autotest_testpath': '',
        \ 'show_summary_cmdline': 1,
        \ }
  return extend(default, g:vimtest_config)
endfunction
