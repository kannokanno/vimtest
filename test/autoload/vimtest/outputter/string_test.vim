let s:testcase = vimtest#new()
let s:testcase.target = vimtest#outputter#string#new()

function! s:testcase.create_progress_message()
  let marks = {'test1':1, 'test2':0, 'test3':0, 'test4':1}
  let results = [s:create_progress_result(marks)]

  let expected_lines = values(map(copy(marks), "vimtest#message#progress_line(v:val, v:key)"))
  " title(runner name)
  let expected_lines = insert(expected_lines, 'test_runner_name')
  " break line
  let expected_lines = add(expected_lines, '')

  call self.assert.equals(
        \ join(expected_lines, "\n"),
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
        \ s:create_count_result(2, 3, 2),
        \ s:create_count_result(1, 2, 1)
        \]

  call self.assert.equals(
        \ vimtest#message#summary(3, 5, 3),
        \ self.target.create_summary_message(results))
endfunction


function! s:create_count_result(progress, passed, failed)
  return {
        \ '_progress': range(a:progress),
        \ '_passed': range(a:passed),
        \ '_failed': range(a:failed),
        \ }
endfunction

function! s:create_progress_result(progress_state)
  return {'_runner_name': 'test_runner_name', '_progress': a:progress_state}
endfunction

function! s:create_message_result(message)
  let result = {'message': a:message}
  function! result.failed_summary()
    return self.message
  endfunction
  return result
endfunction

