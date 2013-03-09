function! vimtest#config#get()
  let default = {
        \ 'outputter'               : 'buffer',
        \ 'autotest_watch_patterns' : [],
        \ 'autotest_testpath'       : '',
        \ 'auto_source'             : 1,
        \ 'show_summary_cmdline'    : 1,
        \ }
  function! default.autotest_cmd(testpath)
    execute "VimTest " . a:testpath
  endfunction
  let override_config = exists('g:vimtest_config') ? g:vimtest_config : {}
  return extend(default, override_config)
endfunction
