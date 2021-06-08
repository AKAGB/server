#!/bin/sh

echo "After pull"
echo `pwd`

echo "update svnlibs"
cd ./svnlibs/
svn up
cd ..