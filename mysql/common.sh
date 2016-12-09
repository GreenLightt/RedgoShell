#! /bin/bash
#####################################################################
#   Goal: Provide Common Function For Other Mysql Moudle
#####################################################################

##################################
# Variable
##################################
config_file=''
database_name=''
# Username to enter mysql
datebase_user=''
# User's password to enter mysql
database_password=''

# Command mysqlDump 's location
mysqldump=''
# Command mysql 's location
mysql=''
# Folder for backup database
back_folder=/tmp/mysql_backup

# Manager of created database
database_manager=''
# Manager password of created database
database_manager_password=''

##################################
# Function
##################################
function ReadConfigFile() {
    while read line
    do
        param_name=$(echo $line | awk '{print $1}')
        param_value=$(echo $line | awk '{print $2}')

        case $param_name in
            'DatabaseName')
                database_name=${param_value//\'/}
                ;;
            'User')
                datebase_user=${param_value//\'/}
                ;;
            'Password')
                database_password=${param_value//\'/}
                ;;
            'MysqlDump')
                mysqldump=${param_value//\'/}
                ;;
            'Mysql')
                mysql=${param_value//\'/}
                ;;
            'Manager')
                database_manager=${param_value//\'/}
                ;;
            'ManagerPassword')
                database_manager_password=${param_value//\'/}
                ;;
        esac
    done < $1
}

function BackupDataBase() {
    # Mkdir
    if [ ! -d $back_folder ]; then
        mkdir $back_folder
    fi

    tmp_file="${back_folder}/${database_name}_$(date +%s).sql"
    $mysqldump -u$datebase_user -p$database_password $database_name > $tmp_file
    echo $tmp_file
}
