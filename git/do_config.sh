#! /bin/bash
#####################################################################
#   目的：Git 仓库配置初始化
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

##################################
# Execute
##################################
# 验证参数
if [ $# -ne 1 ]; then
    Usage
fi

# 验证是否是 Git 仓库
filepath=$(Relative2AbsolutePath $1)
CheckGitFolder $filepath

cd $filepath

# 初始化工作

# config git editor when commit
git config core.editor vim

# config color print when git command
git config color.ui auto

echo  "Finish config."
