#! /bin/bash
#####################################################################
#   Goal: Install Ctags
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
# 安装包
ctags_resource=$current_path"/resources/ctags.gz"
# 解压安装包时，临时存放目录
tmp_ctags_install=/tmp/ctags$(date +%s)

##################################
# Function
##################################

# 功能：解压及编译
# 参数：无
# 返回：无
function InstallCtags() {
    cd $tmp_ctags_install"/ctags"
    ./configure && make && make install
    rm -rf $tmp_ctags_install
}

##################################
# Execute
##################################
# check file
CheckFileExist $ctags_resource
MakeFolderExist $tmp_ctags_install

ctags --help >/dev/null 2>&1
if [ $? -ne 0 ]; then
    tar xvf $ctags_resource -C $tmp_ctags_install >/dev/null
    InstallCtags
else
    echo 'Ctags has installed.'
fi
