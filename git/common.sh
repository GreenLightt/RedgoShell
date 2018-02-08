#! /bin/bash
#####################################################################
#   目的： Git 模块的公共库
#####################################################################

##################################
# Import File
##################################

current_path=$(cd "$(dirname "$0")"; pwd)

# 引入 common 模块的 common.sh
file=$current_path"/../common"/common.sh
if [ ! -f $file ]; then
    echo $file" file is not exist"
    exit 2;
fi
source $file

##################################
# Variable
##################################

# git 库的作者，GetAllAuthor 方法调用之后才有值
authors=()

##################################
# Function
##################################

# 功能：判断给定目录是否是 Git 根目录
# 参数：目录路径
# 返回：无（如果不是 Git 根目录，报错，退出）
function CheckGitRootFolder() {
    git_root_path=$1
    if [ ! -d $git_root_path/.git ]; then
        echo 'Note: '$git_root_path' folder dont container .git folder.'
        exit 2
    fi
}

# 功能：读取指定 Git 目录的 commit 作者
# 参数：目录路径
# 返回：无
function GetAllAuthor() {
    tmp_file="/tmp/"$(basename $0)_$(date +"%s")
    $(cd $1; git log --pretty=format:"%an" | sort -u > $tmp_file) 
    while read author
    do
        if [ "$author" != "" ]; then
            authors=("${authors[@]}" "$author")
        fi
    done < $tmp_file

    RemoveFile $tmp_file
}
