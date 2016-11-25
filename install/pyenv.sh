#! /bin/bash
#####################################################################
#   Goal: Install Pyenv
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
# Function
##################################
function PrepareNeedEnvironment() {
    yum -y install readline readline-devel readline-static
    yum -y install openssl openssl-devel openssl-static
    yum -y install sqlite-devel
    yum -y install bzip2-devel bzip2-libs
}

function Install() {
    echo "Install Begin ..."
    git clone git://github.com/yyuu/pyenv.git ~/.pyenv
    echo ''
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    exec $SHELL -l
    echo "Install Finish."
}

##################################
# Execute
##################################
pyenv rehash >/dev/null 2>&1
if [ $? -ne 0 ]; then
    PrepareNeedEnvironment
    Install

    # Validate install success or not
    pyenv rehash >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo 'Pyenv install success.'
    else
        echo 'Pyenv install fail.'
    fi
else
    echo 'Pyenv has installed.'
fi
