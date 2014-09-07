let s:testcase = vimtest#new()

function! s:testcase.to_string()
  call self.assert.equals(string(10), vimtest#util#to_string(10))
  call self.assert.equals('hoge', vimtest#util#to_string('hoge'))
  call self.assert.equals(string([1,2,'a']), vimtest#util#to_string([1,2,'a']))
  call self.assert.equals(string({'a':1, 2:'b'}), vimtest#util#to_string({'a':1, 2:'b'}))
endfunction

function! s:testcase.to_product_codepath_is_success()
  call self.assert.equals('~/.vim/bundle/vimtest/autoload/vimtest/runner.vim',
        \ vimtest#util#to_product_codepath('~/.vim/bundle/vimtest/test/autoload/vimtest/runner_test.vim'))
  call self.assert.equals('~/.vim/bundle/vimtest/autoload/vimtest.vim',
        \ vimtest#util#to_product_codepath('~/.vim/bundle/vimtest/test/autoload/vimtest_test.vim'))
endfunction

function! s:testcase.to_product_codepath_is_empty_when_not_exists()
  call self.assert.equals('', vimtest#util#to_product_codepath(''))
  call self.assert.equals('',
        \ vimtest#util#to_product_codepath('~/.vim/bundle/vimtest/sample/usage_sample.vim'))
endfunction

function! s:testcase.autocmd_str_return_empty_when_invalid_args()
  call self.assert.equals('', vimtest#util#autocmd_str('', '1'))
  call self.assert.equals('', vimtest#util#autocmd_str('1', ''))
  call self.assert.equals('', vimtest#util#autocmd_str('', ''))
endfunction

function! s:testcase.autocmd_str()
  let event = 'event'
  let filepath = 'filepath'
  let expected = printf('autocmd BufWritePost %s call vimtest#config#get().autotest_cmd("%s")', event, filepath)
  call self.assert.equals(expected, vimtest#util#autocmd_str(event, filepath))
endfunction
