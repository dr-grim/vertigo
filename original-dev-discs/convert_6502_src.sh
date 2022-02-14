#!/bin/bash

if [[ $# -ne 2 ]] ; then
    echo "Expected 2 arguments: <source folder> <destination folder>"
    echo
    echo "Example, to extra original ADE+ source and overwrite 'src' folder:"
    echo "${0##*/} Vertigo-master-backup/0B/e ../src"
    echo
    exit 1
fi

for f in `ls $1`
do
    echo "$1/$f to $2/$f.6502"
    cat $1/$f | \
    sed -E 's/\r/\n/g' | \
    sed -E 's/^([a-zA-Z])/.\1/g' | \
    sed -E 's/^(\s*)\*/;\1\*/g' | \
    sed -E 's/(\s+)EQU(\s+)/\1=\2/g' | \
    sed -E 's/(\s+)DFB(\s+)/\1EQUB\2/g' | \
    sed -E 's/(\s+)DW(\s+)/\1EQUW\2/g' | \
    sed -E 's/(\s+)DS(\s+)/\1SKIP\2/g' | \
    sed -E 's/(\s+)ASC(\s+)/\1EQUS\2/g' | \
    sed -E 's/(\s+)STR(\s+)\"(.+)\"/\1EQUS\2\"\3\", \&0D/g' | \
    sed -E 's/(\s+)TTL(\s+)/;\1TTL\2/g' | \
    sed -E 's/(\s+)CHN(\s+)(.*)/\1INCLUDE\2"\3"/g' | \
    sed -E 's/(.*)\#(.*)<(.*)(;.*)/\1\#\2LO\(\3\)\4/g' | \
    sed -E 's/(.*)\#(.*)<(.*)/\1\#\2LO\(\3\)/g' | \
    sed -E 's/(.*)\#(.*)>(.*)(;.*)/\1\#\2HI\(\3\)\4/g' | \
    sed -E 's/(.*)\#(.*)>(.*)/\1\#\2HI\(\3\)/g' \
    > $2/$f.6502
done