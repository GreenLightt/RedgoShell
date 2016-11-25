#! /bin/bash
#####################################################################
#   Goal: Update Git Commit Author Email
#
#   Note: This command will rewrite git histroy, please think twice!
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
old_email=""
new_email=""

##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) [git_folder]"' ["old_author_email"] ["new_author_email"]'
    # exit status, 2 means Incorrect Usage
    exit 2
}

function UpdateAuthorEmail() {
    
    export OLD_EMAIL=$old_email
    export NEW_EMAIL=$new_email

    git filter-branch --commit-filter \
    'if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]; then
        GIT_AUTHOR_EMAIL="$NEW_EMAIL";
        git commit-tree "$@";
    else
        git commit-tree "$@";
    fi' -f HEAD
}
##################################
# Execute
##################################
# Validate Param
if [ $# -ne 3 ]; then
    Usage
fi

# Validate Git Folder
gitfilepath=$(Relative2AbsolutePath $1)
CheckGitFolder $gitfilepath

old_email=$2
new_email=$3
if [ "$old_email" = "" ]; then
    echo "Error: author's old email is empty string."
    exit 2
fi
if [ "$new_email" = "" ]; then
    echo "Error: author's new email is empty string."
    exit 2
fi

cd $gitfilepath
UpdateAuthorEmail
