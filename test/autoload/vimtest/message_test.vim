let s:testcase = vimtest#new()

function! s:testcase.summary()
  call self.assert.equals("\n\nTest cases run: 10, Passes: 8, Failures: 2\n", vimtest#message#summary(8, 2))
  call self.assert.equals("\n\nTest cases run: 3, Passes: 0, Failures: 3\n", vimtest#message#summary(0, 3))
  call self.assert.equals("\n\nTest cases run: 2, Passes: 2, Failures: 0\n", vimtest#message#summary(2, 0))
  call self.assert.equals("\n\nTest cases run: 0, Passes: 0, Failures: 0\n", vimtest#message#summary(0, 0))
endfunction

function! s:testcase.failure_assert()
  call self.assert.equals("Failed asserting expected <1> but was <2>", vimtest#message#failure_assert(1, 2))
  call self.assert.equals("Failed asserting expected <hoge> but was <piyo>", vimtest#message#failure_assert('hoge', 'piyo'))
  call self.assert.equals("Failed asserting expected <[1, 2]> but was <[2, 1]>", vimtest#message#failure_assert([1,2], [2,1]))
  call self.assert.equals("Failed asserting expected <{'a': 1, 'b': 2}> but was <{'a': 1, 'b': 3}>", vimtest#message#failure_assert({'a':1, 'b':2}, {'a':1, 'b':3}))
endfunction

function! s:testcase.failure_assert()
  call self.assert.equals("Failed asserting not expected <1> but was <2>", vimtest#message#failure_assert_not(1, 2))
  call self.assert.equals("Failed asserting not expected <hoge> but was <piyo>", vimtest#message#failure_assert_not('hoge', 'piyo'))
  call self.assert.equals("Failed asserting not expected <[1, 2]> but was <[2, 1]>", vimtest#message#failure_assert_not([1,2], [2,1]))
  call self.assert.equals("Failed asserting not expected <{'a': 1, 'b': 2}> but was <{'a': 1, 'b': 3}>", vimtest#message#failure_assert_not({'a':1, 'b':2}, {'a':1, 'b':3}))
endfunction

function! s:testcase.exception()
  call self.assert.equals("Excpetion:error_message\n       in point", vimtest#message#exception('error_message', 'point'))
endfunction

function! s:testcase.not_enough_args()
  call self.assert.equals('Not enough args for func. expected 3 but was 2', vimtest#message#not_enough_args('func', 3, 2))
endfunction

function! s:testcase.invalid_bool_arg()
  call self.assert.equals('Invalid arg<[]> type list. valid type is string or num', vimtest#message#invalid_bool_arg([]))
endfunction
