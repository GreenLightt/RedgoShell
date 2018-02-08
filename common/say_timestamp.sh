#! /bin/bash
#####################################################################
#   Goal: According Timestap Get Readability Date
#####################################################################

#############################
# Function
#############################
function Usage() {
    echo "Usage: $(readlink -f $0) timestap ... "
    # exit status, 2 means Incorrect Usage
    exit 2
}

function SayTimeStap() {
    date -d "@$1" +"%Y/%m/%d %H:%M:%S" 2>&1
}

##################################
# Execute
##################################
if [ $# -eq 0 ]; then
    Usage
else
    for param in $@; do
        ret=$(SayTimeStap $param)
        echo "-------------------------------"
        echo "<$param> "$ret
    done
fi
