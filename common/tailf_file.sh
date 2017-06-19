#! /bin/bash
#####################################################################
#   Goal: Tailf File
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

#############################
# Function
#############################
function Usage() {
    echo "Usage: $(readlink -f $0) -f file "
    # exit status, 2 means Incorrect Usage
    exit 2
}

##################################
# Execute
##################################
file=''

while getopts f: option
do
    case "$option" in
        f)
            file=${OPTARG}
            ;;
        \?)
            Usage
            ;;
    esac
done

if [[ "$file" = "" ]] || [[ ! -f $file ]]; then
    Usage
fi

tailf $file | while read -r line;
do
    echo -e $line;
done
