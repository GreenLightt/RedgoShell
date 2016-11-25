#! /bin/bash
#####################################################################
#   Goal: Provide Common Function For Other Git Moudle
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
authors=()

##################################
# Function
##################################
function GetAllAuthor() {
    tmp_file="/tmp/"$(basename $0)_$(date +"%s")
    $(cd $1; git log --pretty=format:"%an" | sort -u > $tmp_file) 
    while read author
    do
        if [ "$author" != "" ]; then
            authors=("${authors[@]}" "$author")
        fi
    done < $tmp_file

    RemoveFile $tmp_file
}
