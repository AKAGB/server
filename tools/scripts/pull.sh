#!/bin/bash
# 拉取逻辑：
# 1. 执行svn update，成功执行3，如果没有GameData目录执行2
# 2. svn co xxx，如果这一步失败了则不往下进行，成功执行进入3
# 3. git pull


cd $(dirname "$0")
# echo `pwd`
GAMEDATA_PAR_DIR="../.."
GAMEDATA_DIR="./svnlibs"
GAMEDATA_URL="svn://svnbucket.com/gongqk/svnlibs/"

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