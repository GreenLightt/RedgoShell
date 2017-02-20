#! /bin/bash
#####################################################################
#   Goal: Update Yum Repo To 163-Repo
#####################################################################

##################################
# Variable
##################################
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
