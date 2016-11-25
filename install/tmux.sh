#! /bin/bash
#####################################################################
#   Goal: Install Tmux
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
tmux_resource=$filepath'/resources/tmux-1.6.tar.gz'
tar_dest=/tmp/tmux$(date +%s)
tmux_conf_resource=$filepath'/resources/tmux.conf'
tmux_conf=/root/.tmux.conf

##################################
# Function
##################################
function InstallSupport() {
    # Install Need Support
    echo "Install Need Support..."
    yum install -y libevent-devel ncurses-devel >/dev/null 2>&1
}

function UnpackageAndCompile() {
    echo "Unpackage "$tmux_resource"..."
    MakeFolderExist $tar_dest

    tar zxvf $tmux_resource -C $tar_dest

    echo "Compile..."
    for file in ` ls $tar_dest `
    do
        tmux_folder=$tar_dest'/'$file
    done

    $(  cd $tmux_folder;
        ./configure;
        make;
        make install;
        make clean;
        make distclean;
    ) >/dev/null 2>&1

    RemoveFolder $tar_dest
}

##################################
# Execute
##################################
# check file
CheckFileExist $tmux_resource
CheckFileExist $tmux_conf_resource

# install and compile
tmux -V >/dev/null 2>&1
if [ $? -ne 0 ]; then
    InstallSupport
    UnpackageAndCompile
else
    echo 'Tmux has installed.'
fi

# configure
echo "Config..."
if [ -f $tmux_conf ]; then
    echo 'Tmux configure file has in /root'
else
    cp $tmux_conf_resource $tmux_conf

    alias_command="alias tmux='tmux -2'"
    grep_ret=$(grep "$alias_command" ~/.bashrc | wc -l)
    if [ $grep_ret -eq 0 ]; then
        echo "" >> ~/.bashrc
        echo $alias_command >> ~/.bashrc
    fi
    echo 'Finished.'
fi
