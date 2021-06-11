#!/bin/bash
# 拉取逻辑：
# 1. 检查当前分支是否绑定了远程分支，若没有则报错退出。否则执行2。
# 2. 执行svn update，成功执行3，如果没有GameData目录执行2
# 3. svn co xxx，如果这一步失败了则不往下进行，成功执行进入3
# 4. git pull


cd $(dirname "$0")

# 1. 检查当前分支是否绑定了远程分支，没有则报错退出
CUR_BRANCH=`git branch | grep \* | cut -d ' ' -f2`
GIT_ORIGIN_URL=`git branch -vv | grep  ${CUR_BRANCH} | grep '\[origin'`
if [ ${#GIT_ORIGIN_URL} -ne 0 ]
then 
    GIT_ORIGIN_URL=`git rev-parse --abbrev-ref ${CUR_BRANCH}@{upstream}`
else 
    echo "[Error] 当前分支未绑定远程分支"
    exit -1
fi 

# 查找SVN URL
if [ ${GIT_ORIGIN_URL} == 'origin/main' ]
then 
    GAMEDATA_URL='svn://svnbucket.com/gongqk/svnlibs/trunk/'
elif [ ${GIT_ORIGIN_URL} == 'origin/dev0.3' ]
then 
    GAMEDATA_URL='svn://svnbucket.com/gongqk/svnlibs/branches/0.3dev/'
fi
# echo ${GIT_ORIGIN_URL}
echo "SVN URL: " ${GAMEDATA_URL}

# echo `pwd`
GAMEDATA_PAR_DIR="../.."
GAMEDATA_DIR="./svnlibs"

cd ${GAMEDATA_PAR_DIR}

# 检查GameData目录是否存在
if [ -d ${GAMEDATA_DIR} ]
then
    echo "Update GameData"
    cd ${GAMEDATA_DIR}
    svn up
else
    echo "Checkout GameData"
    svn co ${GAMEDATA_URL}
    if [ $? -ne 0 ]
    then 
        # 执行失败，退出
        echo "[Error] Cannot checkout GameData."
        exit -1
    fi
fi

# 拉取git
git pull