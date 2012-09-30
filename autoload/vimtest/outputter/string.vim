" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:outputter = vimtest#outputter#instance('string')

function! s:outputter.out(runners)
  let message = ''
  let message .= self.create_progress_message(a:runners)
  let message .= self.create_failed_message(a:runners)
  let message .= self.create_summary_message(a:runners)
  return message
endfunction

" TODO messageの組み立てはこのファイルの責務じゃない
function! s:outputter.create_progress_message(results)
  let message = ''
  for r in a:results
    for p in r.assert._progress
      let message .= p
    endfor
  endfor
  return message
endfunction

" TODO messageの組み立てはこのファイルの責務じゃない
function! s:outputter.create_failed_message(results)
  let message = ''
  for r in a:results
    if !empty(r._result())
      let message .= r._result()
    endif
  endfor
  return message
endfunction

" TODO messageの組み立てはこのファイルの責務じゃない
function! s:outputter.create_summary_message(results)
  let total_passed_count = 0
  let total_failed_count = 0
  for r in a:results
    let total_passed_count += len(r.assert._passed)
    let total_failed_count += len(r.assert._failed)
  endfor
  return vimtest#message#summary(total_passed_count, total_failed_count)
endfunction

function! vimtest#outputter#string#new()
  return deepcopy(s:outputter)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
