" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:outputter = {}
function! s:outputter.init()
endfunction

function! s:outputter.out(runners)
  let total_passed_count = 0
  let total_failed_count = 0
  let failed_messages = []
  let message = ''
  for r in a:runners
    let total_passed_count += len(r.assert._passed)
    let total_failed_count += len(r.assert._failed)
    call add(failed_messages, r._result())
    for p in r.assert._progress
      let message .= p
    endfor
  endfor
  for m in failed_messages
    if !empty(m)
      let message .= m
    endif
  endfor
  let message .= vimtest#message#summary(total_passed_count, total_failed_count)
  return message
endfunction

function! vimtest#outputter#string#new()
  return deepcopy(s:outputter)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
