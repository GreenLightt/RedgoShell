#! /bin/bash
#####################################################################
#   目的：更新 yum 的源为 163 的源
#####################################################################

##################################
# Variable
##################################
# 下载 163 repo 文件的 url 地址
repo163_url="http://mirrors.163.com/.help/CentOS6-Base-163.repo"
repo163=/etc"/yum.repos.d/CentOS6-Base-163.repo"
base_repo=/etc"/yum.repos.d/CentOS-Base.repo"

#############################
# Execute
#############################

if [ -f $base_repo ]; then
    mv $base_repo $base_repo".bak"
fi

wget -P /etc/yum.repos.d $repo163_url 
mv $repo163 $base_repo
