#! /bin/bash
#####################################################################
#   Goal: Add Colorful Out Text For Git Command
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
function Usage() {
    echo "Usage: $(readlink -f $0) [git_folder]"
    # exit status, 2 means Incorrect Usage
    exit 2
}

##################################
# Execute
##################################
# Validate Param
if [ $# -ne 1 ]; then
    Usage
fi

# Validate Git Folder
gitfilepath=$(Relative2AbsolutePath $1)
CheckGitFolder $gitfilepath

cd $gitfilepath
git config  color.status auto
git config  color.diff auto
git config  color.branch auto
git config  color.interactive auto

echo  "Finish color up."
