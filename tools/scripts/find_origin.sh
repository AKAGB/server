#!/bin/bash

if [ $# -lt 1 ]
then
	echo "USAGE: $0 BRANCH_NAME"
	exit 1
fi

BRANCH_NAME=$1

ori=`git branch -vv | grep ${BRANCH_NAME} | grep '\[origin'`
ori=${ori#*[origin/}
ori=${ori%]*}
echo ${ori}
