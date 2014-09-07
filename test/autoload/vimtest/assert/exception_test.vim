" AUTHOR: AmaiSaeta <amaisaeta@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:testcase = vimtest#new('vimtest#assert#exception#new()')

function s:testcase.should_return_new_exception_object()
  let target = vimtest#assert#exception#new('foo', 0)
  call self.assert.equals(type({}), type(target))
  call self.assert.equals('foo', target.expected)
  call self.assert.equals(0, target.is_regexp)

  let target = vimtest#assert#exception#new('bar', 1)
  call self.assert.equals('bar', target.expected)
  call self.assert.equals(1, target.is_regexp)
endfunction

let s:testcase = vimtest#new('vimtest#assert#exception#new_for_vim_error()')

function s:testcase.should_return_new_exception_object_match_vim_errors()
  let target = vimtest#assert#exception#new_for_vim_error('E123')
  call self.assert.equals(type({}), type(target))
  call self.assert.equals('^Vim\%((\a\+)\)\=:E123', target.expected)
  call self.assert.true(target.is_regexp)

  let target = vimtest#assert#exception#new_for_vim_error('E321')
  call self.assert.equals('^Vim\%((\a\+)\)\=:E321', target.expected)
endfunction

let s:testcase = vimtest#new('Exception object''s test(); When the expected is a string')

function! s:testcase.startup()
  let self.target = vimtest#assert#exception#new('foo', 0)
  lockvar self.target
endfunction

function s:testcase.should_return_non_0_when_the_argument_equals_the_expected_error()
  call self.assert.true(self.target.test('foo'))
endfunction

function s:testcase.should_return_0_when_the_argument_differents_the_expected_error()
  call self.assert.false(self.target.test('fo'))
  call self.assert.false(self.target.test('foox'))
  call self.assert.false(self.target.test('xfoo'))
endfunction

let s:testcase = vimtest#new('Exception object''s test(); When the expected is a RegExp')

function! s:testcase.startup()
  let self.target = vimtest#assert#exception#new('^foo', 1)
  lockvar self.target
endfunction

function s:testcase.should_return_non_0_when_the_argument_matchs_the_expected_error()
  call self.assert.true(self.target.test('foo'))
  call self.assert.true(self.target.test('foox'))
endfunction

function s:testcase.should_return_0_when_the_argument_do_not_match_the_expected_error()
  call self.assert.false(self.target.test('fo'))
  call self.assert.false(self.target.test('^foo'))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: expandtab shiftwidth=2 tabstop=2
