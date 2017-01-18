#! /bin/bash
#####################################################################
#   Goal: Install Ctags
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
ctags_resource=$filepath"/resources/ctags.gz"
tmp_ctags_install=/tmp/ctags$(date +%s)

##################################
# Function
##################################
function InstallCtags() {
    cd $tmp_ctags_install"/ctags"
    ./configure && make && make install
    rm -rf $tmp_ctags_install
}

##################################
# Execute
##################################
# check file
CheckFileExist $ctags_resource
MakeFolderExist $tmp_ctags_install

ctags --help >/dev/null 2>&1
if [ $? -ne 0 ]; then
    tar xvf $ctags_resource -C $tmp_ctags_install >/dev/null
    InstallCtags
else
    echo 'Ctags has installed.'
fi
