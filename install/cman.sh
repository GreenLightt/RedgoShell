#! /bin/bash
#####################################################################
#   Goal: Install Man With Chinese Language
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
resource_file=$filepath"/resources/manpages-zh-1.5.1.tar.gz"
tar_dest=/tmp/cman$(date +%s)
zhman_folder=/usr/local/zhman

##################################
# Function
##################################
function InstallChineseSupport() {
    # Install Chinese Support
    echo "Install Chinese Support..."
    yum groupinstall -y "Chinese Support" >/dev/null 2>&1
}

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
