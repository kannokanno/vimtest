let s:testcase = vimtest#new()
let s:testcase.target = vimtest#assert#new()

function! s:testcase.same_values()
  return [
          \[1, 1],
          \['a', 'a'],
          \[[], []],
          \[[1], [1]],
          \[['a'], ['a']],
          \[{'a':1, 'b':2}, {'a':1, 'b':2}],
        \]
endfunction

function! s:testcase.not_same_values()
  return [
          \[1, 0],
          \['a', 0],
          \['a', 'A'],
          \['a', 'b'],
          \[[], [1]],
          \[[1], [2]],
          \[['a'], ['b']],
          \[{'a':1, 'b':2}, {'a':1, 'c':2}],
        \]
endfunction

function! s:testcase.true_values()
  return [1, '1', '1a', -1]
endfunction

function! s:testcase.false_values()
  return [0, 'a', 'a1']
endfunction


function! s:testcase.equals_expected_true()
  for args in self.same_values()
    call self.assert.true(self.target.equals(args[0], args[1]))
  endfor
endfunction

function! s:testcase.equals_expected_false()
  for args in self.not_same_values()
    call self.assert.false(self.target.equals(args[0], args[1]))
  endfor
endfunction

function! s:testcase.not_equals_expected_true()
  for args in self.not_same_values()
    call self.assert.true(self.target.not_equals(args[0], args[1]))
  endfor
endfunction

function! s:testcase.not_equals_expected_false()
  for args in self.same_values()
    call self.assert.false(self.target.not_equals(args[0], args[1]))
  endfor
endfunction

function! s:testcase.true_expected_true()
  for arg in self.true_values()
    call self.assert.true(self.target.true(arg))
  endfor
endfunction

function! s:testcase.true_expected_false()
  for arg in self.false_values()
    call self.assert.false(self.target.true(arg))
    unlet arg
  endfor
endfunction

function! s:testcase.true_expected_false()
  for arg in self.false_values()
    call self.assert.true(self.target.false(arg))
    unlet arg
  endfor
endfunction

function! s:testcase.false_expected_false()
  for arg in self.true_values()
    call self.assert.false(self.target.false(arg))
    unlet arg
  endfor
endfunction
