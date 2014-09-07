let s:testcase = vimtest#new()
let s:testcase.target = vimtest#assert#new('name')

function! s:testcase._simple_assert(expected, actual)
  if a:expected ==# a:actual
    call self.assert.success()
  else
    call self.assert.fail(printf('expected:<%s>, actual:<%s>', a:expected, a:actual))
  endif
endfunction

function! s:testcase._same_values()
  return [
          \[1, 1],
          \['a', 'a'],
          \[[], []],
          \[[1], [1]],
          \[['a'], ['a']],
          \[{'a':1, 'b':2}, {'a':1, 'b':2}],
        \]
endfunction

function! s:testcase._not_same_values()
  return [
          \[1, 0],
          \['a', 0],
          \['', []],
          \['a', 'A'],
          \['a', 'b'],
          \[[], [1]],
          \[[1], [2]],
          \[['a'], ['b']],
          \[{'a':1, 'b':2}, {'a':1, 'c':2}],
        \]
endfunction

function! s:testcase._true_values()
  return [1, '1', '1a', -1]
endfunction

function! s:testcase._false_values()
  return [0, 'a', 'a1']
endfunction

function! s:testcase.equals_expected_true()
  for args in self._same_values()
    call self._simple_assert(1, self.target.equals(args[0], args[1]))
  endfor
endfunction

function! s:testcase.equals_expected_false()
  for args in self._not_same_values()
    call self._simple_assert(0, self.target.equals(args[0], args[1]))
  endfor
endfunction

function! s:testcase.not_equals_expected_true()
  for args in self._not_same_values()
    call self._simple_assert(1, self.target.not_equals(args[0], args[1]))
  endfor
endfunction

function! s:testcase.not_equals_expected_false()
  for args in self._same_values()
    call self._simple_assert(0, self.target.not_equals(args[0], args[1]))
  endfor
endfunction

function! s:testcase.true_expected_true()
  for arg in self._true_values()
    call self._simple_assert(1, self.target.true(arg))
    unlet arg
  endfor
endfunction

function! s:testcase.true_expected_false()
  for arg in self._false_values()
    call self._simple_assert(0, self.target.true(arg))
    unlet arg
  endfor
endfunction

function! s:testcase.true_expected_false()
  for arg in self._false_values()
    call self.assert.true(self.target.false(arg))
    unlet arg
  endfor
endfunction

function! s:testcase.false_expected_false()
  for arg in self._true_values()
    call self.assert.false(self.target.false(arg))
    unlet arg
  endfor
endfunction

function! s:testcase.expected_throw_value()
  call self.assert.false(has_key(self.assert, 'exception'))

  call self.assert.throw('hogehoge')
  call self.assert.true(has_key(self.assert, 'exception'))
  call self.assert.true(self.assert.exception.test('hogehoge'))
  " 値が残っていると実際に「例外が発生したかどうか」のテストが走ってしまうので消す
  call remove(self.assert, 'exception')
endfunction

function! s:testcase.expected_throw()
  call self.assert.false(has_key(self.assert, 'exception'))

  call self.assert.throw('E684')
  let a = remove([], -1)
  " 上で例外指定しているので通る
  call remove(self.assert, 'exception')
endfunction

function! s:testcase.expected_throw_match()
  call self.assert.false(has_key(self.assert, 'exception'))

  call self.assert.throw_match('^foo')
  call self.assert.true(has_key(self.assert, 'exception'))
  throw 'foobar'
  " 上で例外指定しているので通る
  call remove(self.assert, 'exception')
endfunction
