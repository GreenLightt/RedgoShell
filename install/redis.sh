#! /bin/bash
#####################################################################
#   Goal: Auto Install Redis
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
source_file_src=http://download.redis.io/redis-stable.tar.gz
# 下载源文件到指定目录
download_folder=/tmp
# redis文件压缩包的名字
source_file=redis-stable.tar.gz
# 临时安装文件夹
tmp_ctags_install=/tmp/redis$(date +%s)

##################################
# Function
##################################
function InstallRedis() {
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

redis-server --help >/dev/null 2>&1
if [ $? -ne 0 ]; then
    InstallRedis
    rm -rf $tmp_ctags_install

else
    echo 'Redis has installed.'
fi
