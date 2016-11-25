#! /bin/bash
#####################################################################
#   Goal: Count All User Update Line Number According By Time
#         And File Type
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

CheckFileExist $filepath/common.sh
source         $filepath/common.sh

##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) [git_folder]"
    # exit status, 2 means Incorrect Usage
    exit 2
}

function CountNumTotal() {
    author="$1"
    day=$(date -d "$2 1 seconds ago" +'%Y-%m-%d %H:%M:%S')

    git log --author="$author" --pretty=format:"" --numstat --since="$day" |
        gawk '
            BEGIN {
                add = 0; subs = 0; sum = 0;
            }
            { add += $1; subs += $2; sum += $1 - $2 }
            END {
                printf "%9s[+] %9s[-] %9s[+-]", add, subs, sum
            }
            '
}

function CountNumOnce() {
    author="$1"
    day_start=$(date -d "$2 1 seconds ago" +'%Y-%m-%d %H:%M:%S')
    day_end=$(date -d "$day_start 24 hours" +'%Y-%m-%d %H:%M:%S')

    git log --author="$author" --pretty=format:"" --numstat \
            --since="$day_start" --until="$day_end" | \
        gawk '
            BEGIN {
                add = 0; subs = 0; sum = 0;
            }
            { add += $1; subs += $2; sum += $1 - $2 }
            END {
                printf "%9s[+] %9s[-] %9s[+-]", add, subs, sum
            }
            '
}

##################################
# Execute
##################################
# Validate Param
if [ $# -ne 1 ]; then
    Usage
fi

# Validate Git Folder
gitfilepath=$(Relative2AbsolutePath $1)
CheckGitFolder $gitfilepath

GetAllAuthor $gitfilepath

cd $gitfilepath

author_num=${#authors[*]}
for ((i=0; i<$author_num; i++))
do
    author="${authors[$i]}"
    # Today
    today=$(date +'%Y-%m-%d')
    printf "%-20s %-10s%-15s" "$author" "$today" "[today]"
    CountNumOnce "$author" $today
    printf "\n"

    # YesterDay
    yesterday=$(date -d "-1 days" +'%Y-%m-%d')
    printf "%-20s %-10s%-15s" "$author" "$yesterday" "[yesterday]"
    CountNumOnce "$author" $yesterday
    printf "\n"

    # Week
    week=$(date -d "-6 days" +'%Y-%m-%d')
    printf "%-20s %-10s%-15s" "$author" "$week" "[week]"
    CountNumTotal "$author" $week
    printf "\n"

    printf "\n"
done
