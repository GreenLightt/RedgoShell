#! /bin/bash
#####################################################################
#   目的: 为所有模块提供公共方法
#####################################################################

##################################
# 路径
##################################

# 功能：相对路径转绝对路径
# 参数：相对路径的字符串
# 返回：绝对路径值
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
# 文件
##################################

# 功能：判断目录是否存在
# 参数：目录路径
# 返回：无（如果不存在目录，报错，退出）
function CheckFolderExist() {
    if [ ! -d $1 ]; then
        echo $1" folder is not exist"
        exit 2;
    fi
}

# 功能：判断文件是否存在
# 参数：文件路径
# 返回：无（如果不存在文件，报错，退出）
function CheckFileExist() {
    if [ ! -f $1 ]; then
        echo $1" file is not exist"
        exit 2;
    fi
}

# 功能：判断是否是空目录
# 参数：目录路径
# 返回：无（如果目录为空，报错，退出）
function CheckFolderEmpty() {
    if [ $(ls -A "$1") = '' ]; then
        echo $1" folder is indeed empty"
        exit 2;
    fi
}

# 功能：如果目录不存在，则创建此目录
# 参数：目录路径
# 返回：无
function MakeFolderExist() {
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
}

# 功能：如果目录存在，则删除此目录
# 参数：目录路径
# 返回：无
function RemoveFolder() {
    if [ -d $1 ]; then
        rm -rf $1
    fi
}

# 功能：如果文件存在，则删除此文件
# 参数：文件路径
# 返回：无
function RemoveFile() {
    if [ -f $1 ]; then
        rm -rf $1
    fi
}

# 功能：判断目录是否是 Git 目录
# 参数：目录路径
# 返回：无 （如果不是 Git 目录，报错，退出）
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
# 网络
##################################

# 功能：判断 IP 是否可以连接
# 参数：IP
# 返回：ping ip 命令的结果值
function  CheckIPValidate() {
    ping -c 3 -w 10 $1 >/dev/null
    return $?
}

##################################
# Size
##################################

# 功能：获取文件或目录占硬盘空间大小
# 参数：文件或目录路径
# 返回：Size 值
function CountFileOrFolderSize() {
    # s : summary
    # h : print sizes in human readable format (e.g., 1K 234M 2G)
    size=$(du -sh $1 | awk '{print $1}')
    return $size
}

##################################
# 数值
##################################

# 功能：判断参数是否是数值
# 参数：要进行判断的值
# 返回：无（如果不是数值，报错，退出）
function CheckIsNumber() {
    expr $1 + 0 &>/dev/null
    if [ $? -ne 0 ]; then
        echo $1' is not number.'
        exit 2
    fi
}

