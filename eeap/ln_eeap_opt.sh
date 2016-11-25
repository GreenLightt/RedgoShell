#! /bin/bash
#####################################################################
#   Goal: Build Symbolic Links To Make Opt Code As Same As Git Code
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
git_root_dir=/home/eeap/
opt_root_dir=/opt/eeap/
# value's format (opt folder git folder)
exec_arr=("htdocs htdocs" "bkdata/lang lang")

##################################
# Execute
##################################
out_arr_length=${#exec_arr[*]}
for ((i=0; i<$out_arr_length; i++));
do
    item=(${exec_arr[$i]})
    opt_folder_obj=(${item[0]})
    git_folder_obj=(${item[1]})
    opt_folder_obj_full_name=$opt_root_dir""$opt_folder_obj

    # if opt folder is not exist, error return
    CheckFolderExist ${opt_folder_obj_full_name%/*}

    # if git folder is not exist, error return
    CheckFolderExist $git_root_dir""$git_folder_obj

    rm -rf $opt_root_dir""$opt_folder_obj
    ln -sf -t ${opt_folder_obj_full_name%/*} $git_root_dir""$git_folder_obj
    chown -R daemon:daemon $opt_root_dir""$opt_folder_obj
done
