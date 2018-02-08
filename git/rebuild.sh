#! /bin/bash
#####################################################################
#   目的：重构 Git 仓库
#
#   注意：你将会丢弃所有分支，除了当前的分支
#####################################################################

##################################
# Import File
##################################

current_path=$(cd "$(dirname "$0")"; pwd)

# 引入 git 模块的 common.sh
file=$current_path"/common.sh"
if [ ! -f $file ]; then
    echo $file" file is not exist"
    exit 2;
fi
source $file

##################################
# Variable
##################################

##################################
# Function
##################################

# 功能：输出 命令使用说明
# 参数：无
# 返回：无
function Usage() {
    echo "Usage: $(readlink -f $0) [git_folder]"
    # exit status, 2 means Incorrect Usage
    exit 2
}

# 功能：重构 Git 仓库
# 参数：Git 仓库目录路径
# 返回：无
function ReBuild(){
    git_root_path=$1
    cd $git_root_path

    # Record Origin Repo Url
    old_repo_url=$(git config remote.origin.url)
    if [ "$old_repo_url" == "" ]; then
        echo "The repo's remote url is none, please add!"
        exit 2
    fi

    # Remove Old Git Repository
    rm -rf $git_root_path/.git
    git init
    git remote add origin $old_repo_url

    git add .

    echo '==============================================================='
    echo 'Just the last step, you should do : '
    echo "             check author's name and email:"
    echo "                            [git config --list]"
    echo "             if no proplem:"
    echo "                            [git commit -m ':tada: first commit']"
    echo "                            [git push -f -u origin master]"
}

##################################
# Execute
##################################
# Validate Param
if [ $# -ne 1 ]; then
    Usage
fi

# Validate Git Root Folder
CheckGitRootFolder $(Relative2AbsolutePath $1)

ReBuild $(Relative2AbsolutePath $1)
