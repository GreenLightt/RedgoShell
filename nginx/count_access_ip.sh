#! /bin/bash
#####################################################################
#   Goal: Count Ip That Access Nginx
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
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) [-f access.log] {-n threshold_num}"
    # exit status, 2 means Incorrect Usage
    exit 2
}

##################################
# Execute
##################################
# Validate Param
if [ $# -eq 0 ]; then
    Usage
    exit 2;
fi

access_log=''
threshold=0

while getopts f:n: option
do
    case "$option" in
        f)
            access_log=${OPTARG}
            ;;
        n)
            threshold=${OPTARG}
            ;;
        \?)
            ;;
    esac
done

if [[ "$access_log" = "" ]] || [[ ! -f $access_log ]]; then
    echo "The access log <"$access_log"> file is not exist"
    exit 2;
fi

awk '{print $1}' $access_log | sort | uniq -c |sort -n | awk -v threshold=$threshold '$1 > threshold {print $0}'
