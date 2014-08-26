" AUTHOR: AmaiSaeta <amaisaeta@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#assert#exception#new(expected_error, is_regexp)
  let exception = {
        \ 'expected' : a:expected_error,
        \ 'is_regexp' : a:is_regexp,
        \ }

  function exception.test(actual_error)
    return self.is_regexp
          \ ? a:actual_error =~# self.expected
          \ : a:actual_error ==# self.expected
  endfunction

  return exception
endfunction

" The helper for the Vim error assertions.
function! vimtest#assert#exception#new_for_vim_error(error_code)
  let regexp = '^Vim\%((\a\+)\)\=:' . a:error_code
  return vimtest#assert#exception#new(regexp, 1)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: expandtab shiftwidth=2 tabstop=2
