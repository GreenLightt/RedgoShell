#! /bin/bash
#####################################################################
#   Goal: Install Sysbench Tool
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

##################################
# Variable
##################################
sysbench_git_src="https://github.com/akopytov/sysbench.git"
install_fold="/tmp/sysbench_"$(date +"%s")
with_mysql_includes=/opt/bksite/mysql/include/
with_mysql_libs=/opt/bksite/mysql/lib/

##################################
# Function
##################################
function CheckGit() {
    git --version >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo 'Please Install Git'
        exit;
    fi
}

function Download() {
    MakeFolderExist $install_fold
    git clone -b master --depth=1 $sysbench_git_src $install_fold
}

function Config() {
    echo 'Start Config...'
    # Precheck
    CheckFolderExist $with_mysql_includes
    CheckFolderExist $with_mysql_libs

    cd $install_fold
    ./autogen.sh
    ./configure --prefix=/usr/local/sysbench/ --with-mysql-includes=$with_mysql_includes \
        --with-mysql-libs=$with_mysql_libs --with-mysql
    make
    make install

    RemoveFile /usr/local/bin/sysbench
    ln -s /usr/local/sysbench/bin/sysbench /usr/local/bin/

    export_command='export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:'"$with_mysql_libs\""
    grep_ret=$(grep "$export_command" /etc/profile | wc -l)
    if [ $grep_ret -eq 0 ]; then
        echo "" >> /etc/profile
        echo $export_command >> /etc/profile
        echo 'Please excute follow command: source /etc/profile'
    fi
}

function Clear() {
    rm -rf $install_fold
}

##################################
# Execute
##################################
CheckGit
Download
Config
Clear
echo 'Install Success!';
