#! /bin/sh
# file: examples/equality_test.sh

SH_DIR=$(cd $(dirname $0);pwd)

echo ${SH_DIR}

testSuccess()
{
  "${SH_DIR}/../../bin/vimtest" "${SH_DIR}/fixture/success.vim"
  assertEquals 'Return 0 if success' 0 "$?"
}

testFail()
{
  "${SH_DIR}/../../bin/vimtest" "${SH_DIR}/fixture/fail.vim"
  assertEquals 'Return 1 if fail' 1 "$?"
}

# load shunit2
. "${SH_DIR}/../lib/shunit2/src/shunit2"
