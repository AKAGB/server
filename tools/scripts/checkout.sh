#!/bin/bash

# 切换分支逻辑：
# 1. 检查目标分支是否存在，不存在则报错退出。否则进入2。
# 2. 递归查找目标git分支对应的远程分支以及对应svn分支。否则进入3。
# 3. 检查GameData目录是否存在，如果不存在则拉取对应svn分支的GameData，拉取失败则退出。如果存在则进入4。
# 4. 检查GameData分支以及Git分支是否发生修改，如果修改则提示使用者处理完修改再切换分支，然后退出。否则进入5。
# 5. svn switch，switch失败则报错退出。否则进入6。
# 6. 执行git checkout。


if [ $# -lt 1 ]
then
	echo "USAGE: $0 BRANCH_NAME"
	exit 1
fi

cd $(dirname "$0")
BRANCH_NAME=$1

# 1. 检查分支是否存在
check_branch=`git branch | grep -w ${BRANCH_NAME}`
if [ ${#check_branch} -eq 0 ]
then 
    echo "Error: ${BRANCH_NAME} does not exist."
    exit -1
fi 

# 2. 查找目标Git远程分支
GIT_ORIGIN_URL=`./find_origin_recursive.sh ${BRANCH_NAME}`
GAMEDATA_PAR_DIR="../.."
GAMEDATA_DIR="./svnlibs"

cd ${GAMEDATA_PAR_DIR}

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

# 3. 检查GameData目录是否存在
if [ ! -d ${GAMEDATA_DIR} ]
then
    
    echo "Checkout GameData"
    svn co ${GAMEDATA_URL} ${GAMEDATA_DIR}
    if [ $? -ne 0 ]
    then 
        # 执行失败，退出
        echo "[Error] Cannot checkout GameData."
        exit -1
    fi
else 
    cd ${GAMEDATA_DIR}
    # 4. 检查svn分支以及Git分支是否发生修改
    svn_change=`svn status`
    if [ ${#svn_change} -ne 0 ]
    then 
        echo "[Error] SVN发生修改且未提交，请先处理完成再切换分支。"
        exit -1
    fi
    git_change=`git status -s`
    if [ ${#git_change} -ne 0 ]
    then
        echo "[Error] Git存在修改且尚未提交的内容，请先处理完成再切换分支。"
        exit -1
    fi 

    # 5. svn switch
    svn switch ${GAMEDATA_URL}
    if [ $? -ne 0 ]
    then 
        echo "[Error] svn switch失败，请检查是否具有权限。"
        exit -1
    fi 
fi

# 6. 执行git checkout。
git checkout ${BRANCH_NAME}