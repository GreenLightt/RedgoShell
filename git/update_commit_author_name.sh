#! /bin/bash
#####################################################################
#   Goal: Update Git Commit Author Name
#  
#   Note: This command will rewrite git histroy, please think twice!
#####################################################################

##################################
# Import File
##################################

current_path=$(cd "$(dirname "$0")"; pwd)

file=$current_path"/common.sh"
if [ ! -f $file ]; then
    echo $file" file is not exist"
    exit 2;
fi
source $file

##################################
# Variable
##################################
# 旧的作者名
old_name=""
# 新的作者名
new_name=""

##################################
# Function
##################################

# 功能：输出 命令使用说明
# 参数：无
# 返回：无
function Usage() {
    echo "Usage: $(readlink -f $0)"' [git_folder] ["old_author_name"] ["new_author_name"]'
    # exit status, 2 means Incorrect Usage
    exit 2
}

# 功能：更新 author name 信息
# 参数：无
# 返回：无
function UpdateAuthorName() {
    
    export OLD_NAME=$old_name
    export NEW_NAME=$new_name

    git filter-branch --commit-filter \
    'if [ "$GIT_AUTHOR_NAME" = "$OLD_NAME" ]; then
        GIT_AUTHOR_NAME="$NEW_NAME";
        git commit-tree "$@";
    else
        git commit-tree "$@";
    fi' -f HEAD
}

##################################
# Execute
##################################
# Validate Param
if [ $# -ne 3 ]; then
    Usage
fi

# Validate Git Folder
gitfilepath=$(Relative2AbsolutePath $1)
CheckGitFolder $gitfilepath

old_name=$2
new_name=$3
if [ "$old_name" = "" ]; then
    echo "Error: author's old name is empty string."
    exit 2
fi
if [ "$new_name" = "" ]; then
    echo "Error: author's new name is empty string."
    exit 2
fi

cd $gitfilepath
UpdateAuthorName
