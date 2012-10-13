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
command! -nargs=? -complete=file VimTest call vimtest#run(<q-args>, vimtest#config#get().outputter)
command! -nargs=? -complete=file VimTestBuffer call vimtest#run(<q-args>, 'buffer')
command! -nargs=? -complete=file VimTestStdout call vimtest#run(<q-args>, 'stdout')
command! -nargs=? -complete=file VimTestQuickfix call vimtest#run(<q-args>, 'quickfix')

command! -nargs=0 VimTestResettings call vimtest#util#settings()

call vimtest#util#settings()

"let &cpo = s:save_cpo
"unlet s:save_cpo
