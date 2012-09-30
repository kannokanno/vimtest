" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vimtest#runner#new(name)
  let runner = {
        \ '_name'  : a:name,
        \ 'assert' : vimtest#assert#new(),
        \ 'custom' : {},
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

  function! runner.run()
    try
      call self.startup()
      for func in self._get_testcases()
        let self.assert._current_testcase = func
        call self.setup()
        try " エラー時に残りのテストが止まらないようにメソッド呼び出しごとに例外処理する
          call call(self[func], [], self)
        catch
          call self.assert.error(v:exception, v:throwpoint)
        endtry
        call self.teardown()
      endfor
      call self.shutdown()
    catch
      call self.assert.error(v:exception, v:throwpoint)
    endtry
  endfunction

  " TODO test
  " TODO メッセージの組み立てはここじゃなくね？
  " memo:なぜassertじゃなくてここで行っているか->ここでしか扱えない情報があったから
  "  ->self._nameだけ
  "  メッセージの構築は別のファイルに任せて、ここは情報を整理するだけにとどめる
  function! runner._result()
    let failed_messages = []
    if !empty(self.assert._failed)
      call add(failed_messages, printf("\n# %s", self._name))
      for i in range(len(self.assert._failed))
        let f = self.assert._failed[i]
        call add(failed_messages, printf("  %d) %s", i+1, f.testcase))
        call add(failed_messages, printf("      %s\n", f.message))
      endfor
    endif
    return join(failed_messages, "\n")
  endfunction

  function! runner._get_testcases()
    " TODO dirty
    let pattern = join([
          \ 'type(self[v:val]) == type(function("tr"))',
          \ 'v:val != "run"',
          \ 'v:val !~ "^_"',
          \ 'v:val !~ "^assert"',
          \ 'v:val !~ "^startup"',
          \ 'v:val !~ "^setup"',
          \ 'v:val !~ "^teardown"',
          \ 'v:val !~ "^shutdown"',
          \ ], '&&')
    return filter(keys(self), pattern)
  endfunction

  return runner
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
