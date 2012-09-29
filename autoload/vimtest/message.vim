" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#message#summary(passed_count, failed_count)
  " TODO これここ？
  if a:failed_count != 0
    echohl FailMsg | echo 'FAILURES!' | echohl None
  endif
  return printf("\n\nTest cases run: %d, Passes: %d, Failures: %d\n",
        \ a:passed_count + a:failed_count,
        \ a:passed_count,
        \ a:failed_count,
        \ )
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
