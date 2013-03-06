
VimTest
=======

Vim script用テストフレームワーク
xUnitに近い形での記述が出来ます。

使用例
======

### テストコード(成功例)

    let s:testcase = vimtest#new('success test')
    function! s:testcase.sum()
      call self.assert.equals(3, 1 + 2)
    endfunction

### 実行結果

    success test
     [x] sum


    Test cases run: 1, Assertions: 1, Passes: 1, Failures: 0

### テストコード(失敗例)

    let s:testcase = vimtest#new('failure test')
    function! s:testcase.sum()
      call self.assert.equals(3, 1 + 1)
    endfunction

### 実行結果

    failure test
     [ ] sum


    # failure test (in .vim/sample.vim)
     1) 'sum' is FAILED
      Failed asserting that two values are equal
       - expected:3
       +   actual:2

    Test cases run: 1, Assertions: 1, Passes: 0, Failures: 1

実行方法
========

テストコードが書かれているファイルに対して以下のコマンドを実行します。

    :VimTest

引数なしでこのコマンドを実行すると、現在のバッファに対してテストを行います。
専用の出力バッファが作成され、そちらにテスト結果を出力します。


詳しくはhelpをお読みください。
