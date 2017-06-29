#! /bin/bash
#####################################################################
#   Goal: Auto Install MongoDB
#####################################################################

##################################
# Import File
##################################
filepath=$(cd "$(dirname "$0")"; pwd)
file=$filepath"/../common"/common.sh
if [ ! -f $file ]; then
    echo $file" file is not exist"
    exit 2;
fi
source $file

##################################
# Variable
##################################
# redis源文件
source_file_src=https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.5.tgz
# 下载源文件到指定目录
download_folder=/tmp
# redis文件压缩包的名字
source_file=mongodb-linux-x86_64-3.4.5.tgz
# 临时安装文件夹
#tmp_ctags_install=/tmp/mongodb$(date +%s)
tmp_ctags_install=/tmp/mongodb

##################################
# Function
##################################
function InstallMongoDB() {
    wget -P $download_folder $source_file_src
    tar xvf $download_folder'/'$source_file -C $tmp_ctags_install > /dev/null
    cd $tmp_ctags_install'/redis-stable'
    make
    make install
}

##################################
# Execute
##################################
MakeFolderExist $tmp_ctags_install

#redis-server --help >/dev/null 2>&1
#if [ $? -ne 0 ]; then
    InstallMongoDB
#    rm -rf $tmp_ctags_install
#
#else
#    echo 'MongoDB has installed.'
#fi
