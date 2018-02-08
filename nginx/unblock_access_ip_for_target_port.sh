#! /bin/bash
#####################################################################
#   目的：将某个端口的 IP 全部取消限制访问
#####################################################################

##################################
# Variable 
##################################
# iptbales 备份文件路径及名称
backup_iptables_file=/tmp/backup_iptables_file
# 端口号
port=-1

##################################
# Function
##################################

# 功能：输出 命令使用说明
# 参数：无
# 返回：无
function Usage() {
    echo "Usage: $(readlink -f $0) [-p port]"
    # exit status, 2 means Incorrect Usage
    exit 2
}

##################################
# Execute
##################################
# Validate Param Numbers
if [ $# -eq 0 ]; then
    Usage
    exit 2;
fi

# Validate Port Param
while getopts p: option
do
    case "$option" in
        p)
            port=${OPTARG}
            ;;
        \?)
            ;;
    esac
done

if [ $port -eq -1 ]; then
    Usage
    exit 2;
fi

# save ip to file
service iptables save

# backup iptables file
cp /etc/sysconfig/iptables $backup_iptables_file

# delete target port
sed -i '/^.*--dport '$port' -j DROP/d' /etc/sysconfig/iptables

# restart services
service iptables restart
