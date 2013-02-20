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

" result
"
"sample failed message
" [ ] failed
"
"sample error message
" [ ] error_one
" [ ] error_two
"
"
"# sample failed message (in /Users/kanno/.vim/bundle/vimtest/sample/failed_sample.vim)
" 1) 'failed' is FAILED
"  Failed asserting that two values are equal
"   - expected:1
"   +   actual:2
"
"# sample error message (in /Users/kanno/.vim/bundle/vimtest/sample/failed_sample.vim)
" 1) 'error_two' is FAILED
"  Excpetion:Vim:E492: エディタのコマンドではありません:   hoge
"   in function vimtest#run..12978..12981, 行 1
"
" 2) 'error_one' is FAILED
"  Excpetion:Vim(call):E15: 無効な式です: )
"   in function vimtest#run..12978..12980, 行 1
"
"Test cases run: 3, Passes: 0, Failures: 3
"
