#!/bin/bash

# 创建分支逻辑：
# 1. 检查当前分支是否存在，存在则不进行创建，直接退出，否则执行2。
# 2. 检查是否有GameData目录，如果没有先拉取当前分支对应的GameData。否则执行3
# 3. 如果存在则git checkout -b，然后切回当前分支并且执行一次checkout.sh，来确保可以合理切换分支。


if [ $# -lt 1 ]
then
	echo "USAGE: $0 NEW_BRANCH"
	exit 1
fi

cd $(dirname "$0")
# echo `pwd`
NEW_BRANCH=$1

# 判断当前分支是否存在，存在则不执行
check_branch=`git branch | grep -w ${NEW_BRANCH}`
if [ ${#check_branch} -ne 0 ]
then 
    echo "[Error] ${NEW_BRANCH} exists. Cannot create new branch."
    exit -1
fi 

CUR_BRANCH=`git branch | grep \* | cut -d ' ' -f2`
GIT_ORIGIN_URL=`./find_origin_recursive.sh ${CUR_BRANCH}`
GAMEDATA_PAR_DIR="../.."
GAMEDATA_DIR="./svnlibs"
# GAMEDATA_URL="svn://svnbucket.com/gongqk/svnlibs/"

cd ${GAMEDATA_PAR_DIR}

# 检查GameData目录是否存在
if [ ! -d ${GAMEDATA_DIR} ]
then
    # 查找SVN URL
    if [ ${GIT_ORIGIN_URL} == 'origin/main' ]
    then 
        GAMEDATA_URL='svn://svnbucket.com/gongqk/svnlibs/trunk/'
    elif [ ${GIT_ORIGIN_URL} == 'origin/dev0.3' ]
    then 
        GAMEDATA_URL='svn://svnbucket.com/gongqk/svnlibs/branches/0.3dev/'
    fi
    echo "SVN URL: " ${GAMEDATA_URL}
    echo "Checkout GameData"
    svn co ${GAMEDATA_URL} svnlibs/
    if [ $? -ne 0 ]
    then 
        # 执行失败，退出
        echo "[Error] Cannot checkout GameData."
        exit -1
    fi
else 
    git checkout -b ${NEW_BRANCH}
    if [ $? -ne 0 ]
    then 
        # 第一次checkout就失败，可能是因为Git修改有冲突
        echo "[Error] Cannot create new branch."
        exit -1
    fi
    # 必须要创建分支后切过去再切回来一次，确保reflog日志中有记录，否则递归查找会陷入死循环
    git checkout ${CUR_BRANCH} >> /dev/null
    ./tools/scripts/checkout.sh ${NEW_BRANCH}  
    if [ $? -ne 0 ]
    then 
        echo "[Error] Cannot create new branch."
        git branch -D ${NEW_BRANCH}
        exit -1
    fi 
fi

# git checkout -b ${NEW_BRANCH}

if [ $? -ne 0 ]
then 
    # 执行失败，退出
    echo "[Error] Cannot create new branch."
    exit -1
fi

