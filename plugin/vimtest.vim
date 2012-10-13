" FILE: vimtest.vim
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
if exists('g:loaded_vimtest') && g:loaded_vimtest
  finish
endif
let g:loaded_vimtest = 1

let s:save_cpo = &cpo
set cpo&vim

" args1: file path or directory path
command! -nargs=? -complete=file VimTest call vimtest#run(<q-args>, 'buffer')
command! -nargs=? -complete=file VimTestBuffer call vimtest#run(<q-args>, 'buffer')
command! -nargs=? -complete=file VimTestStdout call vimtest#run(<q-args>, 'stdout')
command! -nargs=? -complete=file VimTestQuickfix call vimtest#run(<q-args>, 'quickfix')

let s:config = vimtest#config#get()
augroup __VimTest__
  autocmd!
  for pattern in s:config.autotest_watch_patterns
    execute vimtest#util#autocmd_str(pattern, s:config.autotest_testpath)
  endfor
augroup END

"let &cpo = s:save_cpo
"unlet s:save_cpo
