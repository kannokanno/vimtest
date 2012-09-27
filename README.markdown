# vimtest(v0.0.2)

## What this script

Testing plugin for Vim script

## Usage

initialize testcase instance.

    let testcase = vimtest#new('sample test')

add test method

    function! testcase.sum()
      let x = 1
      let y = 2
      call self.assert.equals(3, x + y)
    endfunction

finally write 'call vimtest#run()' for run testcase

    call vimtest#run()


run

    :source %

result

    .
    Test cases run: 1, Passes: 1, Failures: 0

failed message


    let testcase = vimtest#new('failed test')
    function! testcase.sum()
      let x = 1
      let y = 2
      call self.assert.equals(4, x + y)
    endfunction
    call vimtest#run()


result

    F

    # failed test
      1) sum
          Failed asserting expected:<4> but was:<3>

    FAILURES!
    Test cases run: 1, Passes: 0, Failures: 1


## more

@see sample/sample.vim
