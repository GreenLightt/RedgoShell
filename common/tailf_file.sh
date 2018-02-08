#! /bin/bash
#####################################################################
#   目的：tailf 文件的扩展
#####################################################################

##################################
# Import File
##################################

current_path=$(cd "$(dirname "$0")"; pwd)

# 引入 common 模块的 common.sh
file=$current_path"/../common"/common.sh
if [ ! -f $file ]; then
    echo $file" file is not exist"
    exit 2;
fi
source $file

#############################
# Function
#############################

# 功能：输出 命令使用说明
# 参数：无
# 返回：无
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
