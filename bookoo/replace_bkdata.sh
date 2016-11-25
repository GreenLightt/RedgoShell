#! /bin/bash
#####################################################################
#   Goal: Replace Bkdata And Install.sql With Git's
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

CheckFileExist $filepath'/..'/mysql/common.sh
source         $filepath'/..'/mysql/common.sh

##################################
# Variable
##################################
home_project_folder=/home/bookoo
opt_project_folder=/opt/bookoo
build_folder=$home_project_folder/build
install_sql_backup_folder=/tmp/install_sql_bakcup
bkdata_tgz_bakcup_folder=/tmp/bkdata_tgz_backup

##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) -c copy_database_config_file"
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
        CheckFolderExist $opt_project_folder

        # Backup sql file
        tmp_file=$(BackupDataBase)

        MakeFolderExist $install_sql_backup_folder
        backup_sql=$install_sql_backup_folder/install.sql_$(date +"%F")_$$.bak
        mv -f $build_folder/install.sql $backup_sql
        cp $tmp_file $build_folder/install.sql

        # Backup bkdata.tgz
        MakeFolderExist $bkdata_tgz_bakcup_folder
        backup_bkdata=$bkdata_tgz_bakcup_folder/bkdata.tgz_$(date +"%F")_$$.bak
        mv $home_project_folder/bkdata.tgz $backup_bkdata
        tar -zcvf $home_project_folder/bkdata.tgz $opt_project_folder/bkdata/
        echo '================================================================'
        echo 'Result: Replace success.'
        echo 'And sql backup file is at '$backup_sql
        echo 'And bkdata backup file is at '$backup_bkdata
    else
        echo 'Replace failed.'
    fi
fi
