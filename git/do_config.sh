#! /bin/bash
#####################################################################
#   Goal: Do Some Config For Git Repository
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
filepath=$(Relative2AbsolutePath $1)
CheckGitFolder $filepath

cd $filepath
git config core.editor vim

echo  "Finish config."
