let s:testcase = vimtest#new()

function! s:testcase.setup()
  let self.custom = {'target': vimtest#outputter#string#new()}
endfunction

function! s:testcase.create_progress_message()
  let results = [
        \ s:create_progress_result(['.','F','F','.']),
        \]

  call self.assert.equals(
        \ '.FF.',
        \ self.custom.target.create_progress_message(results))
endfunction

function! s:create_progress_result(progress_chars)
  let assert = {'_progress': a:progress_chars}
  return {'assert': assert}
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
        \ self.custom.target.create_failed_message(results))
endfunction

function! s:create_message_result(message)
  let result = {'message': a:message}
  function! result._result()
    return self.message
  endfunction
  return result
endfunction

function! s:testcase.create_summary_message()
  let results = [
        \ s:create_count_result(3, 2),
        \ s:create_count_result(2, 1)
        \]

  call self.assert.equals(
        \ vimtest#message#summary(5, 3),
        \ self.custom.target.create_summary_message(results))
endfunction

function! s:create_count_result(passed, failed)
  let assert = {
        \ '_passed': range(a:passed),
        \ '_failed': range(a:failed),
        \ }
  return {'assert': assert}
endfunction
