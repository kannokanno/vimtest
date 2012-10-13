" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:outputter = vimtest#outputter#instance('string')

function! s:outputter.out(results)
  let message  = ''
  let message .= self.create_progress_message(a:results)
  let message .= self.create_failed_message(a:results)
  let message .= self.create_summary_message(a:results)
  return message
endfunction

function! vimtest#outputter#string#new()
  return deepcopy(s:outputter)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
