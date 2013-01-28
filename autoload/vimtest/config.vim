function! vimtest#config#get()
  let default = {
        \ 'outputter': 'buffer',
        \ 'autotest_watch_patterns': [],
        \ 'autotest_testpath': '',
        \ 'show_summary_cmdline': 1,
        \ }
  let override_config = exists('g:vimtest_config') ? g:vimtest_config : {}
  return extend(default, override_config)
endfunction
