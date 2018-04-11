#! /bin/bash
#####################################################################
#   目的：切割文件为指定数量的片
#####################################################################

##################################
# Import File
##################################

current_path=$(cd "$(dirname "$0")"; pwd)

# 引入 common 模块的 common.sh
file=$current_path"/../common"/common.sh
if [ ! -f $file ]; then
    echo $file" file is not exist"
    exit 2;
fi
source $file

##################################
# Variable
##################################
# 切片的数量
chip_numbers=1
# 需要切片的文件
split_file=''
# 切片存放的目录
target_folder=''

##################################
# Function
##################################

# 功能：输出 命令使用说明
# 参数：无
# 返回：无
function Usage() {
    echo "Usage: $(readlink -f $0) -f [need_split_file] " \
            "-d [split_to_where] -n [chip_numbers]"
    # exit status, 2 means Incorrect Usage
    exit 2
}

# 功能：切片
# 参数：无
# 返回：无
function SplitFile() {
    # 获取文件大小
    file_size=$(du $split_file| awk '{print $1}')
    # 获取单个切片大小
    block_size=$(expr $(expr $file_size / $chip_numbers) + 1)

    remind_size=$file_size
    for (( i=1; i <= $chip_numbers; i++)); do
        if [ $remind_size -gt $block_size ]; then
            count_size=$block_size
        else
            count_size=$remind_size
        fi
        skip_size=$(expr $block_size \* $(expr $i - 1))

        target_file=$target_folder'/'${split_file##*/}'_'$i
        dd if=$split_file bs=1024 count=$count_size skip=$skip_size of=$target_file
        remind_size=$(expr $remind_size - $block_size)
    done
}

##################################
# Execute
##################################
if [ $# != 6 ]; then
    Usage
else
    while getopts f:d:n: option
    do
        case "$option" in
            f)
                split_file=$OPTARG
                ;;
            d)
                target_folder=$OPTARG
                ;;
            n)
                if [ "$OPTARG" != "0" ]; then
                    chip_numbers=$OPTARG
                fi
                ;;
            \?)
                Usage
                ;;
        esac
    done

    # Validate
    #  Validate Split File
    if [ "$split_file" = "" ];then
        echo 'The value of option -f is empty.'
        exit 2
    fi
    CheckFileExist $split_file

    #  Validate Chip Numbers
    CheckIsNumber $chip_numbers

    #  Validate Target Folder
    if [ "$target_folder" = "" ];then
        echo 'The value of option -d is empty.'
        exit 2
    fi
    target_folder=$(Relative2AbsolutePath $target_folder)
    MakeFolderExist $target_folder

    SplitFile

    if [ $? -eq 0 ]; then
        echo 'Excute success.'
    fi
fi
