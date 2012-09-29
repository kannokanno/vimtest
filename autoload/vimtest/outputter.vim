" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#outputter#instance()
  let s:outputter = {}
  function! s:outputter.init()
  endfunction
  return s:outputter
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
