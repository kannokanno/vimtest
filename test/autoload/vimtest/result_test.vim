let s:testcase = vimtest#new()
let s:testcase.name = 'result test'

function! s:testcase.setup()
  let s:testcase.target = vimtest#result#new(s:testcase.name)
endfunction

function! s:testcase.get_name()
  call self.assert.equals(self.name, self.target._runner_name)
endfunction

function! s:testcase.add_passed_when_success()
  call self.assert.equals(0, len(self.target._passed))
  call self.target.success()
  call self.assert.equals(1, len(self.target._passed))
  call self.target.success()
  call self.assert.equals(2, len(self.target._passed))
endfunction

function! s:testcase.add_progress_when_success_in_another_testcase()
  let testcase_name1 = 'sample_test1'
  let self.target._current_testcase = testcase_name1
  call self.target.success()
  call self.assert.equals(1, self.target._progress[testcase_name1])

  let testcase_name2 = 'sample_test2'
  let self.target._current_testcase = testcase_name2
  call self.target.success()
  call self.assert.equals(1, self.target._progress[testcase_name1])
endfunction

function! s:testcase.add_progress_when_success_in_same_testcase()
  let testcase_name = 'sample_test'
  let self.target._current_testcase = testcase_name
  call self.target.success()
  call self.assert.equals(1, self.target._progress[testcase_name])
  call self.target.success()
  call self.assert.equals(1, self.target._progress[testcase_name])
endfunction

" success -> faliedで値が書き変わること
function! s:testcase.update_progress_status()
  let testcase_name = 'sample_test'
  let self.target._current_testcase = testcase_name
  call self.target.success()
  call self.assert.equals(1, self.target._progress[testcase_name])
  call self.target.fail()
  call self.assert.equals(0, self.target._progress[testcase_name])
endfunction

function! s:testcase.add_failed_when_fail()
  call self.assert.equals(0, len(self.target._failed))
  call self.target.fail()
  call self.assert.equals(1, len(self.target._failed))
  call self.target.fail()
  call self.assert.equals(2, len(self.target._failed))
endfunction

function! s:testcase.add_F_in_progress_when_fail()
  let testcase_name1 = 'sample_test1'
  let self.target._current_testcase = testcase_name1
  call self.target.fail()
  call self.assert.equals(0, self.target._progress[testcase_name1])

  let testcase_name2 = 'sample_test2'
  let self.target._current_testcase = testcase_name2
  call self.target.fail()
  call self.assert.equals(0, self.target._progress[testcase_name2])
endfunction

function! s:testcase.add_errored_when_error()
  call self.assert.equals(0, len(self.target._failed))
  call self.target.error('', '')
  call self.assert.equals(1, len(self.target._failed))
  call self.target.error('', '')
  call self.assert.equals(2, len(self.target._failed))
endfunction

function! s:testcase.add_E_in_progress_when_error()
  let testcase_name1 = 'sample_test1'
  let self.target._current_testcase = testcase_name1
  call self.target.error('', '')
  call self.assert.equals(0, self.target._progress[testcase_name1])

  let testcase_name2 = 'sample_test2'
  let self.target._current_testcase = testcase_name2
  call self.target.error('', '')
  call self.assert.equals(0, self.target._progress[testcase_name2])
endfunction

