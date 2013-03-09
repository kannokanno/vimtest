" FILE: vimtest.vim
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
if exists('g:loaded_vimtest') && g:loaded_vimtest
  finish
endif
let g:loaded_vimtest = 1

let s:save_cpo = &cpo
set cpo&vim

function! VimTestRunTerminal(path, outfile)
  " 強制的に上書き
  let g:vimtest_config = {
        \ 'show_summary_cmdline': 0,
        \ 'auto_source': 0
        \ }

  try
    if filewritable(a:outfile)
      " reset
      call writefile([], a:outfile)
    endif
    let save_vfile = &verbosefile
    let &verbosefile = a:outfile
    silent! call vimtest#run(expand(a:path), 'stdout')
  finally
    " TODO あとで消す
    echo strftime("%Y/%m/%d (%a) %H:%M:%S")
    echo "\r\r"
    if &verbosefile ==# a:outfile
      let &verbosefile = save_vfile
    endif
  endtry
endfunction

" args1: file path or directory path
command! -nargs=? -complete=file VimTest call vimtest#run(<q-args>, vimtest#config#get().outputter)
command! -nargs=? -complete=file VimTestBuffer call vimtest#run(<q-args>, 'buffer')
command! -nargs=? -complete=file VimTestStdout call vimtest#run(<q-args>, 'stdout')
command! -nargs=? -complete=file VimTestQuickfix call vimtest#run(<q-args>, 'quickfix')

command! -nargs=0 VimTestResettings call vimtest#util#settings()

call vimtest#util#settings()

let &cpo = s:save_cpo
unlet s:save_cpo
