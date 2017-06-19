#! /bin/bash
#####################################################################
#   Goal: Pyenv Install
#####################################################################

#############################
# Function
#############################
function Usage() {
    echo "Usage: $(readlink -f $0) python-version "
    # exit status, 2 means Incorrect Usage
    exit 2
}

#############################
# Execute
#############################
if [[ $# != 1 ]]; then
    Usage
else
    version=$1
    wget http://mirrors.sohu.com/python/$version/Python-$version.tar.xz -P ~/.pyenv/cache/
    pyenv install $version
fi
