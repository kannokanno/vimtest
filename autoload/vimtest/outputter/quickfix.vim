" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:outputter = vimtest#outputter#instance('quickfix')

function! s:outputter.out(results)
  let qflist = []
  for result in a:results
    for fail in result._failed
      let qfmsg = printf("%s\n%s", fail.testcase, fail.message)
      call add(qflist, s:create_qf(result, qfmsg))
    endfor
  endfor

  call setqflist(qflist)
  cwindow
endfunction

function! s:create_qf(result, failed_msg)
  return {
        \ 'filename': a:result._filepath,
        \ 'lnum'    : 1,
        \ 'text'    : a:failed_msg
        \ }
endfunction

function! vimtest#outputter#quickfix#new()
  return deepcopy(s:outputter)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
