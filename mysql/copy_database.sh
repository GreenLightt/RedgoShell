#! /bin/bash
#####################################################################
#   Goal: Copy Mysql Database
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

CheckFileExist $filepath/common.sh
source         $filepath/common.sh

##################################
# Variable
##################################
back_folder=/tmp/mysql_backup

##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) -c config_file"
    # exit status, 2 means Incorrect Usage
    exit 2
}

function ValidateConfigFile() {
    CheckFileExist $1
    # Validate File Format
    format=$(cat $1 | awk '{print $1}' | tr '\n' ' ')
    if [ "$format" != "# DatabaseName User Password MysqlDump " ]; then
        echo "$1 is not need config file"
        exit 2
    fi
}

##################################
# Execute
##################################
if [ $# != 2 ]; then
    Usage
else
    while getopts c: option
    do
        case "$option" in
            c)
                config_file=$(Relative2AbsolutePath "$OPTARG")
                ValidateConfigFile $config_file
                ReadConfigFile $config_file
                ;;
            \?)
                Usage
                ;;
        esac
    done
    if [ "$database_name" != "" ]; then
        echo "Start backup ..."
        tmp_file=$(BackupDataBase)
        echo "End backup. The Backup File is "$tmp_file
    else
        echo "Backup failed."
    fi
fi
