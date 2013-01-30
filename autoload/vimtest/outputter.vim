" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#outputter#instance(name)
  let s:outputter = {'_name': a:name}

  function! s:outputter.init()
  endfunction

  " TODO messageの組み立てはこのファイルの責務じゃない
  function! s:outputter.create_progress_message(results)
    let message = ''
    for r in a:results
      let message .= join(r._progress, "\n")
    endfor
    return message
  endfunction

  " TODO messageの組み立てはこのファイルの責務じゃない
  function! s:outputter.create_failed_message(results)
    let message = ''
    for r in a:results
      if !empty(r.failed_summary())
        let message .= r.failed_summary()
      endif
    endfor
    return message
  endfunction

  " TODO messageの組み立てはこのファイルの責務じゃない
  function! s:outputter.create_summary_message(results)
    let total_passed_count = 0
    let total_failed_count = 0
    for r in a:results
      let total_passed_count += len(r._passed)
      let total_failed_count += len(r._failed)
    endfor
    return vimtest#message#summary(total_passed_count, total_failed_count)
  endfunction

  function! s:outputter.online_summary(results)
    let summary = self.create_summary_message(a:results)
    return substitute(summary, "\n", '', 'g')
  endfunction

  return s:outputter
endfunction

function! vimtest#outputter#get(type)
  if a:type ==? 'buffer'
    return vimtest#outputter#buffer#new()
  elseif a:type ==? 'stdout'
    return vimtest#outputter#stdout#new()
  elseif a:type ==? 'quickfix'
    return vimtest#outputter#quickfix#new()
  else
    return vimtest#outputter#buffer#new()
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
