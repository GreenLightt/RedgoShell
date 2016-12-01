#! /bin/bash
#####################################################################
#   Goal: Install Vim Help With Chinese Language
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
resource_file=$filepath"/resources/vimcdoc-1.8.0.tar.gz"
tar_dest=/tmp/chelp$(date +%s)
vim_folder=/root/.vim

##################################
# Execute
##################################
CheckFileExist $resource_file

if [ -d $vim_folder ]; then
    echo $vim_folder' folder has exist.'
else
    mkdir -p $vim_folder

    echo "Unpackage "$resource_file"..."
    MakeFolderExist $tar_dest
    tar zxvf $resource_file -C $tar_dest >/dev/null 2>&1
    for file in ` ls $tar_dest `
    do
        chelp_folder=$tar_dest'/'$file
    done

    cp -rf $chelp_folder'/doc' $vim_folder
    RemoveFolder $tar_dest

    echo "Config..."
    exec_command="set helplang=cn"
    grep_ret=$(grep "$exec_command" ~/.vimrc | wc -l)
    if [ $grep_ret -eq 0 ]; then
        echo "" >> ~/.vimrc
        echo $exec_command >> ~/.vimrc
    fi

    echo "Finish."
fi
