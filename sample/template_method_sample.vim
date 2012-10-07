let s:testcase = vimtest#new('template method')
function! s:testcase.startup()
  echo 'startup'
endfunction
function! s:testcase.setup()
  echo '  setup'
endfunction
function! s:testcase.test_one()
  echo '   test one'
endfunction
function! s:testcase.test_two()
  echo '   test two'
endfunction
function! s:testcase.test_three()
  echo '   test three'
endfunction
function! s:testcase.teardown()
  echo '  teardown'
endfunction
function! s:testcase.shutdown()
  echo 'shutdown'
endfunction


" result
"
" startup
"   setup
"    test two
"   teardown
"   setup
"    test three
"   teardown
"   setup
"    test one
"   teardown
" shutdown
