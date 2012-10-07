let s:testcase = vimtest#new()
let s:testcase.name = 'result test'

function! s:testcase.setup()
  let s:testcase.target = vimtest#result#new(s:testcase.name)
endfunction

function! s:testcase.get_name()
  call self.assert.equals(self.name, self.target._name)
endfunction

function! s:testcase.add_passed_when_success()
  call self.assert.equals(0, len(self.target._passed))
  call self.target.success()
  call self.assert.equals(1, len(self.target._passed))
  call self.target.success()
  call self.assert.equals(2, len(self.target._passed))
endfunction

function! s:testcase.add_dot_in_progress_when_success()
  call self.target.success()
  call self.assert.equals(['.'], self.target._progress)
  call self.target.success()
  call self.assert.equals(['.', '.'], self.target._progress)
endfunction

function! s:testcase.add_failed_when_fail()
  call self.assert.equals(0, len(self.target._failed))
  call self.target.fail()
  call self.assert.equals(1, len(self.target._failed))
  call self.target.fail()
  call self.assert.equals(2, len(self.target._failed))
endfunction

function! s:testcase.add_F_in_progress_when_fail()
  call self.target.fail()
  call self.assert.equals(['F'], self.target._progress)
  call self.target.fail()
  call self.assert.equals(['F', 'F'], self.target._progress)
endfunction

function! s:testcase.add_errored_when_error()
  call self.assert.equals(0, len(self.target._failed))
  call self.target.error('', '')
  call self.assert.equals(1, len(self.target._failed))
  call self.target.error('', '')
  call self.assert.equals(2, len(self.target._failed))
endfunction

function! s:testcase.add_E_in_progress_when_error()
  call self.target.error('', '')
  call self.assert.equals(['E'], self.target._progress)
  call self.target.error('', '')
  call self.assert.equals(['E', 'E'], self.target._progress)
endfunction

