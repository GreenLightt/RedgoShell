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
mysql=/opt/bksite/mysql/bin/mysqldump
back_folder=/tmp/mysql_backup

##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) -c config_file"
    # exit status, 2 means Incorrect Usage
    exit 2
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
