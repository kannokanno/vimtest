let s:testcase = vimtest#new()
let s:testcase.name = 'result test'

function! s:testcase.setup()
  let s:testcase.target = vimtest#result#new(s:testcase.name)
endfunction

function! s:testcase.get_name()
  call self.assert.equals(self.name, self.target._runner_name)
endfunction

function! s:success_mark(name)
  return printf(' [x] %s', a:name)
endfunction

function! s:fail_mark(name)
  return printf(' [ ] %s', a:name)
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
  call self.assert.equals([s:success_mark(testcase_name1)], self.target._progress)

  let testcase_name2 = 'sample_test2'
  let self.target._current_testcase = testcase_name2
  call self.target.success()
  call self.assert.equals([s:success_mark(testcase_name1), s:success_mark(testcase_name2)], self.target._progress)
endfunction

" TODO: 同じテストケース内では何回成功しても1つだけ追加される
function! s:testcase.add_progress_when_success_in_same_testcase()
  let testcase_name = 'sample_test'
  let mark = s:success_mark(testcase_name)
  let self.target._current_testcase = testcase_name
  call self.target.success()
  call self.assert.equals([mark], self.target._progress)
  "call self.target.success()
  "call self.assert.equals(['.', '.'], self.target._progress)
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
  call self.assert.equals([s:fail_mark(testcase_name1)], self.target._progress)

  let testcase_name2 = 'sample_test2'
  let self.target._current_testcase = testcase_name2
  call self.target.fail()
  call self.assert.equals([s:fail_mark(testcase_name1), s:fail_mark(testcase_name2)], self.target._progress)
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
  call self.assert.equals([s:fail_mark(testcase_name1)], self.target._progress)

  let testcase_name2 = 'sample_test2'
  let self.target._current_testcase = testcase_name2
  call self.target.error('', '')
  call self.assert.equals([s:fail_mark(testcase_name1), s:fail_mark(testcase_name2)], self.target._progress)
endfunction

