#! /bin/bash
#####################################################################
#   Goal: Deploy Eeap Project
#
#   Note: short-option p means package project to specified folder,
#         short-option i means install package
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
root_dir=/home/eeap/
build_dir=$root_dir/build/
output_dir=$root_dir/output/


##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) [-pi]
p means package
i means install"
    # exit status, 2 means Incorrect Usage
    exit 2
}

function Package() {
    # delete output dir's file
    rm -rf $output_dir/*

    # generate deploy file to output dir
    bash $build_dir/build.sh
}

function Install() {
    # stop opt service
    /opt/bksite/ctlscript.sh stop

    # rm /opt
    rm -rf /opt/*

    # find the only file in output dir and bash it
    CheckFolderEmpty $output_dir
    for file in ` ls $output_dir `
    do
        bash $output_dir/$file
    done

    # update php.ini line 1903: 1800->1
    sed -i "1903s/1800/1/g" /opt/bksite/php/etc/php.ini

    # change config to open debug mode
    sed -i '/$CFG->debug/s#\/\/ ##g' /opt/eeap/htdocs/config.php
}

##################################
# Execute
##################################
if [ $# -gt 1 ]; then
    Usage
elif [ $# -eq 1 ]; then
    while getopts pi option
    do
        case "$option" in
            p)
                Package
                ;;
            i)
                Install
                ;;
            \?)
                Usage
                ;;
        esac
    done
elif [ $# -eq 0 ]; then
    Usage
fi
