" FILE: syntax/vimtest.vim
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.

if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" colors
execute 'highlight default VimTestSuccess ctermfg=Green guifg=Green'
execute 'highlight default VimTestFailure ctermfg=DarkRed guifg=DarkRed'

" each test status
" TODO パターン内の指定範囲のみハイライト適用ってどう書けばいいの？
" success pattern
" [x] something_test
syntax match VimTestStatusSuccessPattern '^ \[x\] \w*$' contains=VimTestStatusSuccess
syntax match VimTestStatusSuccess ' \w*' contained
" failure pattern
" [ ] something_test
syntax match VimTestStatusFailurePattern '^ \[ \] \w*$' contains=VimTestStatusFailure
syntax match VimTestStatusFailure '\w*' contained

" failure detail
syntax match VimTestFailureDetail "^\s*\d\+) '\w\+' is FAILED"

" summary result
syntax match VimTestResult
      \ '^Test cases run: \d\+, Passes: \d\+, Failures: \d\+'
      \ contains=VimTestAllSuccess,VimTestSomeFailures
syntax match VimTestAllSuccess 'Failures: 0' contained
syntax match VimTestSomeFailures 'Failures: [1-9]\d*'   contained

" success highlight
highlight default link VimTestStatusSuccess  VimTestSuccess
highlight default link VimTestAllSuccess     VimTestSuccess

" failure highlight
highlight default link VimTestStatusFailure  VimTestFailure
highlight default link VimTestFailureDetail  VimTestFailure
highlight default link VimTestSomeFailures   VimTestFailure

let b:current_syntax = 'vimtest'

let &cpo = s:save_cpo
unlet s:save_cpo
