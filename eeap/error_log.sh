#! /bin/bash
#####################################################################
#   Goal: Print Nginx Error Log File
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
error_log_file=/opt/bksite/nginx/logs/error.log

##################################
# Execute
##################################
CheckFileExist $error_log_file

tailf $error_log_file | while read -r line;
do
    echo -e $line;
done
