let s:testcase = vimtest#new()
let s:testcase.target = vimtest#outputter#string#new()

function! s:testcase.create_progress_message()
  let marks = ['.','F','F','.']
  let results = [
        \ s:create_progress_result(marks),
        \]

  call self.assert.equals(
        \ join(marks, "\n"),
        \ self.target.create_progress_message(results))
endfunction

function! s:testcase.create_failed_message()
  let message1 = 'Failed 1\n'
  let message2 = 'Failed 2\n'
  let results = [
        \ s:create_message_result(message1),
        \ s:create_message_result(''),
        \ s:create_message_result(message2)
        \]

  call self.assert.equals(
        \ message1 . message2,
        \ self.target.create_failed_message(results))
endfunction

function! s:testcase.create_summary_message()
  let results = [
        \ s:create_count_result(3, 2),
        \ s:create_count_result(2, 1)
        \]

  call self.assert.equals(
        \ vimtest#message#summary(5, 3),
        \ self.target.create_summary_message(results))
endfunction


function! s:create_count_result(passed, failed)
  return {
        \ '_passed': range(a:passed),
        \ '_failed': range(a:failed),
        \ }
endfunction

function! s:create_progress_result(progress_chars)
  return {'_progress': a:progress_chars}
endfunction

function! s:create_message_result(message)
  let result = {'message': a:message}
  function! result.failed_summary()
    return self.message
  endfunction
  return result
endfunction

