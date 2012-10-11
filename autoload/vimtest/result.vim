" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#result#new(name)
  let result = {
        \ '_filepath'         : expand('%:p'),
        \ '_name'             : a:name,
        \ '_progress'         : [],
        \ '_passed'           : [],
        \ '_failed'           : [],
        \ '_current_testcase' : '',
        \ }

  function! result.success()
    call insert(self._passed, {})
    call add(self._progress, '.')
  endfunction

  function! result.fail(...)
    let message = len(a:000) > 0 ? a:1 : 'called result.fail()'
    call s:insert(self._failed, self._current_testcase, message)
    call add(self._progress, 'F')
  endfunction

  function! result.error(exception, throwpoint)
    let message = vimtest#message#exception(a:exception, a:throwpoint)
    call s:insert(self._failed, self._current_testcase, message)
    call add(self._progress, 'E')
  endfunction

  function! result.failed_summary()
    let failed_messages = []
    if !empty(self._failed)
      call add(failed_messages, printf("\n# %s (in %s)", self._name, self._filepath))
      for i in range(len(self._failed))
        let f = self._failed[i]
        call add(failed_messages, printf(" %d) '%s' is FAILED", i+1, f.testcase))
        call add(failed_messages, printf("  %s\n", f.message))
      endfor
    endif
    return join(failed_messages, "\n")
  endfunction

  return result
endfunction

function! s:insert(list, testcase, message)
  call insert(a:list, {
        \ 'testcase': a:testcase,
        \ 'message': a:message,
        \ })
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
