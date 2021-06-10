#!/bin/bash

# 创建分支逻辑：
# 1. 检查是否有GameData目录，如果没有先拉取当前分支对应的GameData，然后执行2，否则失败
# 2. git创建新的分支，如果失败则退出，否则进入3
# 3. 保存当前新分支与GameData的对应关系

if [ $# -lt 1 ]
then
	echo "USAGE: $0 NEW_BRANCH"
	exit 1
fi

cd $(dirname "$0")
# echo `pwd`
NEW_BRANCH=$1
GAMEDATA_PAR_DIR="../.."
GAMEDATA_DIR="./svnlibs"
GAMEDATA_URL="svn://svnbucket.com/gongqk/svnlibs/"

cd ${GAMEDATA_PAR_DIR}

# 检查GameData目录是否存在
if [ ! -d ${GAMEDATA_DIR} ]
then
    echo "Checkout GameData"
    svn co ${GAMEDATA_URL}
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

# Save git-svn mapping
