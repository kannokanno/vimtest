let s:testcase = vimtest#new('sample failed message')
function! s:testcase.failed()
  call self.assert.equals(1, 2)
endfunction

let s:testcase = vimtest#new('sample error message')
function! s:testcase.error_one()
  call self.assert.equals(1, [)
endfunction
function! s:testcase.error_two()
  hoge
endfunction

function! s:testcase.not_throw()
  call self.assert.throw('E492')
endfunction

" result
"
"sample failed message
" [ ] failed
"
"sample error message
" [ ] not_throw
" [ ] error_one
" [ ] error_two
"
"
"# sample failed message (in sample/failed_sample.vim)
" 1) 'failed' is FAILED
"  Failed asserting that two values are equal
"   - expected:1
"   +   actual:2
"
"# sample error message (in sample/failed_sample.vim)
" 1) 'error_two' is FAILED
"  Exception:Vim:E492: エディタのコマンドではありません:   hoge
"   in function vimtest#run..497..500, 行 1
"
" 2) 'error_one' is FAILED
"  Exception:Vim(call):E15: 無効な式です: )
"   in function vimtest#run..497..499, 行 1
"
" 3) 'not_throw' is FAILED
"  Expected exception E492. but does not occur
"
"Test cases run: 4, Assertions: 4, Passes: 0, Failures: 4
