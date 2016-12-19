#! /bin/bash
#####################################################################
#   Goal: Split File To Target Dir In Target Chip
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
chip_numbers=1
split_file=''
target_folder=''

##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) -f [need_split_file] " \
            "-d [split_to_where] -n [chip_numbers]"
    # exit status, 2 means Incorrect Usage
    exit 2
}

##################################
# Execute
##################################
if [ $# != 6 ]; then
    Usage
else
    while getopts f:d:n: option
    do
        case "$option" in
            f)
                echo 'f '$OPTARG
                ;;
            d)
                echo 'd '$OPTARG
                ;;
            n)
                echo 'n '$OPTARG
                ;;
            \?)
                Usage
                ;;
        esac
    done
fi
