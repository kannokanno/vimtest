let s:testcase = vimtest#new()

"'HogeHogeTest' is FAILED
" - expected:1
" +   actual:2

function! s:testcase.summary()
  let template = "Test cases run: %d, Assertions: %d, Passes: %d, Failures: %d\n"
  call self.assert.equals(printf(template, 6, 10, 8, 2), vimtest#message#summary(6, 8, 2))
  call self.assert.equals(printf(template, 2, 3, 0, 3), vimtest#message#summary(2, 0, 3))
  call self.assert.equals(printf(template, 1, 2, 2, 0), vimtest#message#summary(1, 2, 0))
  call self.assert.equals(printf(template, 0, 0, 0, 0), vimtest#message#summary(0, 0, 0))
endfunction

function! s:testcase.failure_assert()
  let pattern  = "Failed asserting that two values are equal"
  let pattern .= "\n"
  let pattern .= "   - expected:%s"
  let pattern .= "\n"
  let pattern .= "   +   actual:%s"
  call self.assert.equals(printf(pattern, 1, 2), vimtest#message#failure_assert(1, 2))
  call self.assert.equals(printf(pattern, 'hoge', 'piyo'), vimtest#message#failure_assert('hoge', 'piyo'))
  call self.assert.equals(printf(pattern, string([1,2]), string([2,1])), vimtest#message#failure_assert([1,2], [2,1]))
  call self.assert.equals(printf(pattern, string({'a':1, 'b':2}), string({'a':1, 'b':3})), vimtest#message#failure_assert({'a':1, 'b':2}, {'a':1, 'b':3}))
endfunction

" TODO assert_not test

function! s:testcase.exception()
  call self.assert.equals("Exception:error_message\n   in point", vimtest#message#exception('error_message', 'point'))
endfunction

function! s:testcase.not_enough_args()
  call self.assert.equals('Not enough args for func. expected 3 but was 2', vimtest#message#not_enough_args('func', 3, 2))
endfunction

function! s:testcase.invalid_bool_arg()
  call self.assert.equals('Invalid arg<[]> type list. valid type is string or num', vimtest#message#invalid_bool_arg([]))
endfunction
