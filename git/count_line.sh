#! /bin/bash
#####################################################################
#   目的：统计指定 Git 仓库下各作者的修改行数
#####################################################################

##################################
# Import File
##################################
current_path=$(cd "$(dirname "$0")"; pwd)

# 引入 git 模块的 common.sh
file=$current_path"/common.sh"
if [ ! -f $file ]; then
    echo $file" file is not exist"
    exit 2;
fi
source $file

##################################
# Function
##################################

# 功能：输出 命令使用说明
# 参数：无
# 返回：无
function Usage() {
    echo "Usage: $(readlink -f $0) [git_folder]"
    # exit status, 2 means Incorrect Usage
    exit 2
}

# 功能：统计某一天的数目，并输出到屏幕
# 参数: 作者名 指定时间
# 返回：无
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

# 功能：统计自从某一天之后的数目，并输出到屏幕
# 参数: 作者名 指定时间
# 返回：无
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
