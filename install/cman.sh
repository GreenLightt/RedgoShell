#! /bin/bash
#####################################################################
#   目的：安装中文版的 Man
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
resource_file=$current_path"/resources/manpages-zh-1.5.1.tar.gz"
# 解压安装包时，临时存放目录
tar_dest=/tmp/cman$(date +%s)
# 安装位置
zhman_folder=/usr/local/zhman

##################################
# Function
##################################

# 功能：安装依赖
# 参数：无
# 返回：无
function InstallChineseSupport() {
    # Install Chinese Support
    echo "Install Chinese Support..."
    yum groupinstall -y "Chinese Support" >/dev/null 2>&1
}

# 功能：解压及编译
# 参数：无
# 返回：无
function UnpackageAndCompile() {
    echo "Unpackage "$resource_file"..."
    MakeFolderExist $tar_dest

    tar zxvf $resource_file -C $tar_dest >/dev/null 2>&1
    echo "Compile..."
    for file in ` ls $tar_dest `
    do
        cman_folder=$tar_dest'/'$file
    done

    cd $cman_folder
    ./configure --prefix=/usr/local/zhman --disable-zhtw
    make
    make install

    RemoveFolder $tar_dest
}

##################################
# Execute
##################################
if [ ! -d $zhman_folder ]; then
    InstallChineseSupport
    UnpackageAndCompile
else
    echo $zhman_folder ' folder has exist.'
fi
echo "Config..."
exec_command="alias cman='man -M /usr/local/zhman/share/man/zh_CN'"
grep_ret=$(grep "$exec_command" ~/.bashrc | wc -l)
if [ $grep_ret -eq 0 ]; then
    echo "" >> ~/.bashrc
    echo $exec_command >> ~/.bashrc
fi

echo "Finished. Please execute comand \"source ~/.bashrc\""
