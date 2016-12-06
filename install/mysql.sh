#! /bin/bash
#####################################################################
#   Goal: Auto Install Mysql
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
install_config_file=$filepath'/resources/install_mysql_config.conf'

##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) bitnami_install_resource"
    # exit status, 2 means Incorrect Usage
    exit 2
}

function IsPortOccupied() {
    port=$1
    pid_num=`lsof -i:$port | wc -l`
    if [ $pid_num -gt 0 ]; then
        echo "Port $port has been occupied."
    fi
}

function InstallMysql() {
    run_file=$1
    chmod 755 $run_file
    echo 'Please wait ...'
    $run_file --optionfile $install_config_file --mode unattended
}

##################################
# Execute
##################################
if [ $# != 1 ]; then
    Usage
else
    # Judge Install Resource OK
    echo "Check install resource file..."
    resource=$1
    $resource --help >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$resource file is not a bitnami mysql run file."
        exit 2
    fi
    echo 'Ok.'

    # Judge Install Config File Exist
    CheckFileExist $install_config_file

    # Judge Port Is Occupied
    mysql_port=`grep mysql_port $install_config_file | cut -d"=" -f 2`
    IsPortOccupied $mysql_port

    # Install
    InstallMysql $resource

    if [ $? -eq 0 ]; then
        install_folder=`grep prefix $install_config_file | cut -d"=" -f 2`
        # Finish
        echo "Mysql has been installed in $install_folder, and port is $mysql_port "
    fi
fi
