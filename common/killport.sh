#! /bin/bash
#####################################################################
#   目的: 杀指定端口
#####################################################################

#############################
# Function
#############################

# 功能：输出 命令使用说明
# 参数：无
# 返回：无
function Usage() {
    echo "Usage: $(readlink -f $0) -p port~number "
    # exit status, 2 means Incorrect Usage
    exit 2
}

# 功能：杀占用指定端口的进程
# 参数：端口号
# 返回：无
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
                # 先判断当前端口上有几个进程占用
                pid_num=`lsof -i:${OPTARG} | wc -l`
                # 如果存在进程，则可以杀
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
