#! /bin/bash
#####################################################################
#   目的：阻止超出指定访问 Nginx 次数 的 IP 继续访问
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

##################################
# Variable
##################################
# Nginx 的访问日志
access_log=''
# 门槛值
threshold=0
# 阻止访问的端口
default_port=80
# 结果输出文件
default_block_ip_file=/tmp/block_ip.conf

##################################
# Function
##################################

# 功能：输出 命令使用说明
# 参数：无
# 返回：无
function Usage() {
    echo "Usage: $(readlink -f $0) [-f access.log] {-n threshold_num} {-p port} {-o /tmp/block_ip.conf}"
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

while getopts f:o:p:n: option
do
    case "$option" in
        f)
            access_log=${OPTARG}
            ;;
        o)
            default_block_ip_file=${OPTARG}
            ;;
        p)
            default_port=${OPTARG}
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

tail -n 40000 $access_log \
    | awk '{print $1}' | sort | uniq -c |sort -n \
    | awk -v threshold=$threshold '$1 > threshold {print $0}' \
    | while read -r line;
    do
        a=(`echo $line`)
        # log ip that been blocked
        echo ${a[1]} >> $default_block_ip_file
        # set iptables
        iptables -I INPUT -p tcp --dport $default_port -s ${a[1]} -j DROP
    done

echo -e "\033[40;32m The ip that been blocked has been logged into $default_block_ip_file \033[0m"
