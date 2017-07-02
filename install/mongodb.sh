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
tmp_ctags_install=/tmp/mongodb$(date +%s)
# 正规存放 mongodb 的位置
mongodb_folder=/home/mongodb

##################################
# Function
##################################
function InstallMongoDB() {
    wget -P $download_folder $source_file_src
    tar xvf $download_folder'/'$source_file -C $tmp_ctags_install > /dev/null
    # 将解压出的文件移动到 /usr/local/mongodb 下
    mv  $tmp_ctags_install'/mongodb-linux-x86_64-3.4.5'/ $mongodb_folder
    cd $mongodb_folder
    # 创建数据库目录
    mkdir -p data/db
    # 创建日志目录
    mkdir -p logs
}

##################################
# Execute
##################################
MakeFolderExist $tmp_ctags_install

if [ ! -d $mongodb_folder ]; then
    InstallMongoDB
    rm -rf $tmp_ctags_install
    rm -rf /tmp/$source_file
    echo 'MongoDB install successd in '$mongodb_folder
else
    echo 'MongoDB has installed.'
fi
