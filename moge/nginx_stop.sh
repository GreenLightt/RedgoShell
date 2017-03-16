#! /bin/bash
#####################################################################
#   Goal: Stop Nginx And Php-fpm Service
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
ctlscript_file=/opt/bksite/ctlscript.sh

##################################
# Execute
##################################
CheckFileExist $ctlscript_file

$ctlscript_file stop nginx
$ctlscript_file stop php-fpm
