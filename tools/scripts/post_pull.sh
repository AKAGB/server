#!/bin/sh

echo "After pull"
echo `pwd`

WORK_PATH=$(cd $(dirname "$0") && pwd )
echo $WORK_PATH
echo "update svnlibs"
cd ./svnlibs/
svn up
cd ..