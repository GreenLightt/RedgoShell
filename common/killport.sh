#! /bin/bash
#####################################################################
#   Goal: Kill Specified Port
#####################################################################

#############################
# Function
#############################
function Usage() {
    echo "Usage: $(readlink -f $0) -p port~number "
    # exit status, 2 means Incorrect Usage
    exit 2
}

function Kill() {
    lsof -i:$1 | sed '1d' | while read line
    do
        $(echo $line | awk '{print $2}' | xargs kill -9)
    done
}

#############################
# Execute
#############################
if [ $# != 2 ]; then
    Usage
else
    while getopts p: option
    do
        case "$option" in
            p)
                pid_num=`lsof -i:${OPTARG} | wc -l`
                if [ $pid_num -gt 0 ]; then
                    Kill $OPTARG
                    echo 'success: kill -9 '$OPTARG
                else
                    echo "Port "$OPTARG" not exist"
                fi
                ;;
            \?)
                Usage
                ;;
        esac
    done
fi
