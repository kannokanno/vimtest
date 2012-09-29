" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:outputter = {}
function! s:outputter.init()
endfunction
function! s:outputter.out(runners)
  let str = vimtest#outputter#string#new()
  echo str.out(a:runners)
endfunction

function! vimtest#outputter#stdout#new()
  return deepcopy(s:outputter)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
