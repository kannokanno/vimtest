let s:testcase = vimtest#new()

function! s:testcase.setup()
  let self.config_tmp = get(g:, 'vimtest_config', {})
endfunction

function! s:testcase.teardown()
  let g:vimtest_config = self.config_tmp
endfunction

function! s:testcase.config_default()
  let g:vimtest_config = {}
  let actual = vimtest#config#get()
  call self.assert.equals('buffer', actual.outputter)
  call self.assert.equals([], actual.autotest_watch_patterns)
  call self.assert.equals('', actual.autotest_testpath)
  call self.assert.equals(1, actual.show_summary_cmdline)
  call self.assert.equals(0, actual.show_only_test_fail)
endfunction

function! s:testcase.config_setting()
  let g:vimtest_config = {
        \ 'autotest_watch_patterns': ['~/.vim/hoge', '*.vim'],
        \ 'autotest_testpath': '~/tmp/test',
        \ }
  let actual = vimtest#config#get()
  call self.assert.equals(['~/.vim/hoge', '*.vim'], actual.autotest_watch_patterns)
  call self.assert.equals( '~/tmp/test', actual.autotest_testpath)
endfunction

function! s:testcase.config_rewrite()
  let g:vimtest_config = {
        \ 'autotest_watch_patterns': ['~/.vim/hoge', '*.vim'],
        \ }
  let actual = vimtest#config#get()
  call self.assert.equals(['~/.vim/hoge', '*.vim'], actual.autotest_watch_patterns)

  let g:vimtest_config = {}
  let actual = vimtest#config#get()
  call self.assert.equals([], actual.autotest_watch_patterns)
endfunction
