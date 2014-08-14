" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#runner#new(name)
  let runner = {
        \ 'assert' : vimtest#assert#new(a:name),
        \ }

  function! runner.startup()
    " override by user
  endfunction
  function! runner.setup()
    " override by user
  endfunction
  function! runner.teardown()
    " override by user
  endfunction
  function! runner.shutdown()
    " override by user
  endfunction

  " TODO dirty(処理フロー、例外処理、mock処理などいろいろ含まれているから)
  function! runner._run()
    try
      call self.startup()
      for func in self._get_testcases()
        call self.assert.set_current_testcase(func)
        call self.setup()
        try " エラー時に残りのテストが止まらないようにメソッド呼び出しごとに例外処理する
          call call(self[func], [], self)
          call vimtest#util#safety_call('vmock#verify')
        catch /.*/
          if vimtest#util#get_error_id(v:exception) ==# self.assert.current_expected_throw
            call self.assert.success()
            let self.assert.current_expected_throw = ''
          elseif v:exception ==# self.assert.current_expected_throw
            call self.assert.success()
            let self.assert.current_expected_throw = ''
          else
            call self.assert.error(v:exception, v:throwpoint)
          endif
        finally
          call vimtest#util#safety_call('vmock#clear')
        endtry

        if !empty(self.assert.current_expected_throw)
          call self.assert.fail(vimtest#message#not_occur(self.assert.current_expected_throw))
          let self.assert.current_expected_throw = ''
        endif
        call self.teardown()
      endfor
      call self.shutdown()
    catch
      call self.assert.error(v:exception, v:throwpoint)
    endtry
  endfunction

  function! runner._get_testcases()
    let ignore_pattern = join([
          \ 'type(self[v:val]) ==# type(function("tr"))',
          \ 'v:val !~# "^_"',
          \ 'v:val !=# "startup"',
          \ 'v:val !=# "setup"',
          \ 'v:val !=# "teardown"',
          \ 'v:val !=# "shutdown"',
          \ ], '&&')
    return filter(keys(self), ignore_pattern)
  endfunction

  return runner
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
