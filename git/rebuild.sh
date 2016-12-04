#! /bin/bash
#####################################################################
#   Goal: Build Git Repository And Remove Old Repository
#
#   Note: you will discard all branch except current branch!
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

git_common_path=$filepath/common.sh
CheckFileExist $git_common_path
source $git_common_path

do_config_file_path=$filepath/do_config.sh

##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) [git_folder]"
    # exit status, 2 means Incorrect Usage
    exit 2
}

function ReBuild(){
    git_root_path=$1
    cd $git_root_path

    # Record Origin Repo Url
    old_repo_url=$(git config remote.origin.url)
    if [ "$old_repo_url" == "" ]; then
        echo "The repo's remote url is none, please add!"
        exit 2
    fi

    # Remove Old Git Repository
    rm -rf $git_root_path/.git
    git init
    git remote add origin $old_repo_url

    git add .

    echo '==============================================================='
    echo 'Just the last step, you should do : '
    echo "             check author's name and email:"
    echo "                            [git config --list]"
    echo "             if no proplem:"
    echo "                            [git commit -m ':tada: first commit']"
    echo "                            [git push -f -u origin master]"
}

##################################
# Execute
##################################
# Validate Param
if [ $# -ne 1 ]; then
    Usage
fi

# Validate Git Root Folder
git_root_path=$(Relative2AbsolutePath $1)
#CheckGitFolder $git_root_path
CheckGitRootFolder $git_root_path

ReBuild $git_root_path
