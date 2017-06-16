#! /bin/bash
#####################################################################
#   Goal: UnBlock Access Ip For Target Port
#####################################################################

##################################
# Variable 
##################################
backup_iptables_file=/tmp/backup_iptables_file

##################################
# Function
##################################
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
port=-1

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
