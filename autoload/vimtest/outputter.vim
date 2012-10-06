" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#outputter#instance(name)
  let s:outputter = {'_name': a:name}
  function! s:outputter.init()
  endfunction
  return s:outputter
endfunction

function! vimtest#outputter#get(type)
  if a:type ==? 'buffer'
    return vimtest#outputter#buffer#new()
  elseif a:type ==? 'stdout'
    return vimtest#outputter#stdout#new()
  else
    return vimtest#outputter#buffer#new()
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
