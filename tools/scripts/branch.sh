#!/bin/bash

# 创建分支逻辑：
# 1. 检查当前分支是否存在，存在则不进行创建，直接退出，否则执行2。
# 2. 检查是否有GameData目录，如果没有先拉取当前分支对应的GameData（先进行一步查找），然后执行3，否则失败.
# 3. git创建新的分支，如果失败则退出。


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
    echo "Error: ${NEW_BRANCH} exists. Cannot create new branch."
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
    if [ ${GIT_ORIGIN_URL} == 'main' ]
    then 
        GAMEDATA_URL='svn://svnbucket.com/gongqk/svnlibs/trunk/'
    elif [ ${GIT_ORIGIN_URL} == 'dev0.3' ]
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
fi

git checkout -b ${NEW_BRANCH}

if [ $? -ne 0 ]
then 
    # 执行失败，退出
    echo "[Error] Cannot create new branch."
    exit -1
fi

