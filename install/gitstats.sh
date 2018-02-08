#! /bin/bash
#####################################################################
#   Goal: Install Gitstats For Report Git Project
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
# 存放源代码目录
gitstats_container=/tmp

##################################
# Function 
##################################

# 功能：安装依赖
# 参数：无
# 返回：无
function InstallGnuplot() {
    gnuplot -V >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        yum install -y gnuplot
    else
        echo 'Gnuplot has installed.'
    fi
}

##################################
# Execute
##################################
MakeFolderExist $gitstats_container

InstallGnuplot

git clone git://github.com/hoxu/gitstats.git $gitstats_container'/gitstats'

echo "----------------------------------------------------------"
echo "Gitstats Usage: "
echo "                 cd" $gitstats_container"/gitstats"
echo "                 ./gitstats [git_project] [generate_file_folder]"
