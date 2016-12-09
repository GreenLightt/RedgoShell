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
    echo $format
    if [ "$format" != "# DatabaseName User Password Mysql Manager ManagerPassword " ]; then
        echo "$1 is not need config file"
        exit 2
    fi
}

function CreateDatabase() {
    $mysql -u$datebase_user -p$database_password \
        -e "CREATE DATABASE
            IF NOT EXISTS $database_name
            DEFAULT CHARSET utf8 COLLATE utf8_general_ci;"
}

function CreateDatabaseManager() {
    $mysql -u$datebase_user -p$database_password \
        -e "CREATE USER '$database_manager'@'localhost'
            IDENTIFIED BY '$database_manager_password';" \
        -e "GRANT ALL PRIVILEGES ON $database_name.*
            TO '$database_manager'@'localhost'
            IDENTIFIED BY '$database_manager_password';" \
        -e "flush privileges;"
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
        echo "Start Create ..."
        CreateDatabase
        CreateDatabaseManager
        echo "Create Success."
    else
        echo "Create failed."
    fi
fi
