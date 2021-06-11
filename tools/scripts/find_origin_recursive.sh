#!/bin/bash

# 查找逻辑：
# 1. 根据git branch -vv查询是否有远程分支
# 2. 如果不存在远程分支，则递归查找当前分支的父分支（根据reflog查找最早的一条checkout to [当前分支]）
# 3. 如果递归查找父分支时某条分支存在远程分支，则查找结果就是目标本地分支对应的远程分支

if [ $# -lt 1 ]
then
	echo "USAGE: $0 BRANCH_NAME"
	exit 1
fi

function find_origin()
{
    ori=`git branch -vv | grep $1 | grep '\[origin'`
    if [ ${#ori} -eq 0 ]
    then 
        return 1
    else 
        git rev-parse --abbrev-ref $1@{upstream}
        # echo ${ori}
        return $?
    fi
}

function find_parent()
{
    par=`git reflog --date=local | grep $1 | tail -1`
    par=`echo ${par#*from} | awk '{print $1}'`
    echo ${par}
    return $?
}

BRANCH_NAME=$1

# 检查分支是否存在
check_branch=`git branch | grep -w ${BRANCH_NAME}`
if [ ${#check_branch} -eq 0 ]
then 
    echo "Error: ${BRANCH_NAME} does not exist"
    exit -1
fi 

ori=$(find_origin ${BRANCH_NAME})
# echo ${ori}
# par=$(find_parent ${BRANCH_NAME})
# echo ${par}

while [ $? -ne 0 ]
do 
    # 如果没有远程分支，说明是本地分支，则查reflog该分支是从哪条分支分出来的
    # echo ${BRANCH_NAME}
    BRANCH_NAME=$(find_parent ${BRANCH_NAME})
    ori=$(find_origin ${BRANCH_NAME})
done

# echo "Last Branch:" ${BRANCH_NAME}
echo ${ori}

