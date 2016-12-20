#! /bin/bash
#####################################################################
#   Goal: Provide Common Function For All Moudle
#####################################################################

##################################
# Path
##################################
function Relative2AbsolutePath() {
    if [[ ${1:0:1} = "." ]]; then
        filepath=$(cd "$1"; pwd)
    elif [[ ${1:0:1} = "/" ]]; then
        filepath=$1
    else
        filepath=$(pwd)"/"$1
    fi
    echo $filepath
}

##################################
# File
##################################
function CheckFolderExist() {
    if [ ! -d $1 ]; then
        echo $1" folder is not exist"
        exit 2;
    fi
}

function CheckFileExist() {
    if [ ! -f $1 ]; then
        echo $1" file is not exist"
        exit 2;
    fi
}

function CheckFolderEmpty() {
    if [ $(ls -A "$1") = '' ]; then
        echo $1" folder is indeed empty"
        exit 2;
    fi
}

function MakeFolderExist() {
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
}

function RemoveFolder() {
    if [ -d $1 ]; then
        rm -rf $1
    fi
}

function RemoveFile() {
    if [ -f $1 ]; then
        rm -rf $1
    fi
}

function CheckGitFolder() {
    # Set Filepath
    filepath=$(Relative2AbsolutePath $1)

    # Validate Folder Is Exist
    CheckFolderExist $filepath

    # Validate Folder Is Git Repository
    $(cd $filepath; git log >/dev/null 2>&1)
    if [ $? != 0 ]; then
        echo 'Note: '$filepath' folder is not a git repository'
        exit 2;
    fi
}

##################################
# Network
##################################
function  CheckUrlValidate() {
    ping -c 3 -w 10 $1 >/dev/null
    return $?
}

##################################
# Count Size
##################################
function CountFileOrFolderSize() {
    # s : summary
    # h : print sizes in human readable format (e.g., 1K 234M 2G)
    size=$(du -sh $1 | awk '{print $1}')
    return $size
}

##################################
# Number
##################################
function CheckIsNumber() {
    expr $1 + 0 &>/dev/null
    if [ $? -ne 0 ]; then
        echo $1' is not number.'
        exit 2
    fi
}
