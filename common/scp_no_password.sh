#! /bin/bash
#####################################################################
#   目的：与目的主机进行免密传输
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

# 生成 ssh 文件要存放的目录
ssh_folder=~/.ssh
# 要生成 ssh 文件的名称
ssh_file='id_rsa_'$(date +%s%N)
# 目标主机的 IP 地址
ip=''

##################################
# Function
##################################

# 功能：输出 命令使用说明
# 参数：无
# 返回：无
function Usage() {
    echo "Usage: $(readlink -f $0) -t host "
    # exit status, 2 means Incorrect Usage
    exit 2
}

# 功能：生成 SSH 文件
# 参数：无
# 返回：无
function GenerateSshFile() {
    echo 'Generate ssh file : '$ssh_folder'/'$ssh_file

    cd $ssh_folder
    ssh-keygen -t rsa -P '' -f $ssh_file
}

# 功能：将生成的 SSH 信息存放进 SSH 的配置文件
# 参数：无
# 返回：无
function DoSshConfig() {
    echo "
Host $ip
     HostName $ip
     User $USER
     PreferredAuthentications publickey
     IdentityFile ${ssh_folder}/${ssh_file}
" >> ~/.ssh/config
}

##################################
# Execute
##################################
if [ $# != 2 ]; then
    Usage
else
    while getopts t: option
    do
        case "$option" in
            t)
                echo 'Try ping host ...'
                CheckIPValidate $OPTARG
                if [ $? -eq 0 ]; then
                    ssh_file='id_rsa_'$OPTARG
                    ip=$OPTARG

                    # 生成 ssh 文件，添加到配置，传输到目标主机
                    GenerateSshFile
                    scp $ssh_folder'/'$ssh_file'.pub' $OPTARG':/tmp'
                    DoSshConfig
                    # 最后一步 需要在目标主机执行的命令 进行提示
                    echo "Please execute the following command in target host: "
                    echo "    cat /tmp/${ssh_file}.pub >> ~/.ssh/authorized_keys"
                else
                    echo 'Could not ping '$OPTARG
                fi
                ;;
            \?)
                Usage
                ;;
        esac
    done
fi
