#! /bin/bash
#####################################################################
#   目的：Shell 环境下自动补全 Git 命令
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
# 自动补全需要的源文件
completion_file=$current_path"/resources/git-completion.bash"
# 自动补全命令
exec_command="source "$completion_file
# bashrc 文件位置
bashrc_path="/root/.bashrc"

##################################
# Execute
##################################
# Validate completion_file Exist Or Not
CheckFileExist $completion_file

# 判断 bashrc 文件中是否已经加载 自动补全 命令
grep_result=$(grep "$exec_command" $bashrc_path | wc -l)

if [ $grep_result -eq 0 ]; then
    echo "" >> $bashrc_path
    echo "# auto complete git command" >> $bashrc_path
    echo $exec_command >> $bashrc_path
fi
