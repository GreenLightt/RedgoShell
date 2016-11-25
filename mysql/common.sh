#! /bin/bash
#####################################################################
#   Goal: Provide Common Function For Other Mysql Moudle
#####################################################################

##################################
# Variable
##################################
config_file=''
database_name=''
datebase_user=''
database_password=''

mysql=/opt/bksite/mysql/bin/mysqldump
back_folder=/tmp/mysql_backup

##################################
# Function
##################################
function ReadConfigFile() {
    CheckFileExist $1
    # Validate File Format
    format=$(cat $1 | awk '{print $1}' | tr '\n' ' ')
    if [ "$format" != "# DatabaseName User Password " ]; then
        echo "$1 is not need config file"
    fi
    # Read
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
        esac
    done < $1
}

function BackupDataBase() {
    # mkdir
    if [ ! -d $back_folder ]; then
        mkdir $back_folder
    fi

    tmp_file="${back_folder}/${database_name}_$(date +%s).sql"
    $mysql -u$datebase_user -p$database_password $database_name > $tmp_file
    echo $tmp_file
}
