function! s:test_conf(name)
  let conf = printf('%s/%s', g:vimtest_current_dir, a:name)
  return filereadable(conf) ? conf : 'NONE'
endfunction

function! s:lanucher_vim_command()
  let default_command = 'vim'
  try
    " NOTE: 起動Vimを知るためだけに一度sourceしている
    let s:vimrc = g:vimtest_current_dir . '/.vimrc'
    if filereadable(s:vimrc)
      execute 'source ' . s:vimrc
      return get(g:, 'vimtest_vim_command', default_command)
    else
      return default_command
    endif
  catch
      return default_command
  endtry
endfunction

let s:root_dir = expand('<sfile>:h:h')
let s:bin_dir = expand('<sfile>:h')
function! s:build_cmd()
  let s:cmd  = printf('silent! !%s', s:lanucher_vim_command())
  let s:cmd .= ' -i ' . s:test_conf('.viminfo')
  " NOTE: --cmdを実行させるために必ず何かしらのvimrcを読み込む
  let s:cmd .= ' -u ' . s:test_conf('.vimrc')
  let s:cmd .= ' -U ' . s:test_conf('.gvimrc')
  let s:cmd .= ' -N'
  let s:cmd .= printf(' -c "let &runtimepath .= \",%s\""', s:root_dir)
  let s:cmd .= ' -c "runtime plugin/vimtest.vim"'
  let s:cmd .= printf(' -c "call VimTestRunTerminal(\"%s\", \"%s\")"', expand(g:vimtest_testpath), g:vimtest_outfile)
  let s:cmd .= ' -c "qa"'
  return s:cmd
endfunction

execute s:build_cmd()
