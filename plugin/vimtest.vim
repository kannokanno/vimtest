" FILE: vimtest.vim
" AUTHOR: kanno <akapanna@gmail.com>
" Last Change: 2012 Mar 26
" License: This file is placed in the public domain.
"if exists('g:loaded_vimtest') && g:loaded_vimtest
"  finish
"endif
"let g:loaded_vimtest = 1

let s:save_cpo = &cpo
set cpo&vim

" args1: file path or directory path
command! -nargs=? -complete=file VimTest call vimtest#run('<args>', 'buffer')
command! -nargs=? -complete=file VimTestBuffer call vimtest#run('<args>', 'buffer')
command! -nargs=? -complete=file VimTestString call vimtest#run('<args>', 'string')
command! -nargs=? -complete=file VimTestStdout call vimtest#run('<args>', 'stdout')

"let &cpo = s:save_cpo
"unlet s:save_cpo
