" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#result#new(name)
  let result = {
        \ '_filepath'         : '',
        \ '_runner_name'      : a:name,
        \ '_progress'         : {},
        \ '_passed'           : [],
        \ '_failed'           : [],
        \ '_current_testcase' : '',
        \ }

  function! result.success()
    call insert(self._passed, {})
    call self.update_progress_status(1, self._current_testcase)
  endfunction

  function! result.fail(...)
    let message = len(a:000) > 0 ? a:1 : 'called result.fail()'
    call s:insert(self._failed, self._current_testcase, message)
    call self.update_progress_status(0, self._current_testcase)
  endfunction

  function! result.error(exception, throwpoint)
    let message = vimtest#message#exception(a:exception, a:throwpoint)
    call s:insert(self._failed, self._current_testcase, message)
    call self.update_progress_status(0, self._current_testcase)
  endfunction

  function! result.failed_summary()
    let failed_messages = []
    if !empty(self._failed)
      call add(failed_messages, printf("\n# %s (in %s)", self._runner_name, self._filepath))
      for i in range(len(self._failed))
        let f = self._failed[i]
        call add(failed_messages, printf(" %d) '%s' is FAILED", i+1, f.testcase))
        call add(failed_messages, printf("  %s\n", f.message))
      endfor
    endif
    return join(failed_messages, "\n")
  endfunction

  " TODO dict関数にしたくない
  " TODO 汚い
  function! result.update_progress_status(status, testcase)
    if empty(a:testcase)
      return
    endif
    " NOTE: _progress = {testcase: status(bool)}
    if has_key(self._progress, a:testcase)
      if self._progress[a:testcase] ==# 1 && a:status ==# 0
        " update fail status
        let self._progress[a:testcase] = 0
      endif
    else
      let self._progress[a:testcase] = a:status
    endif
    return self._progress[a:testcase]
  endfunction

  return result
endfunction

function! s:progress_line(mark, name)
  return printf(' [%s] %s', a:mark, a:name)
endfunction

function! s:insert(list, testcase, message)
  call insert(a:list, {
        \ 'testcase': a:testcase,
        \ 'message': a:message,
        \ })
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
