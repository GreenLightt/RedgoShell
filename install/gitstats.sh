#! /bin/bash
#####################################################################
#   Goal: Install Gitstats For Report Git Project
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
gitstats_container=/tmp

##################################
# Function 
##################################
function InstallGnuplot() {
    gnuplot -V >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        yum install -y gnuplot
    else
        echo 'Gnuplot has installed.'
    fi
}

##################################
# Execute
##################################
MakeFolderExist $gitstats_container

InstallGnuplot

git clone git://github.com/hoxu/gitstats.git $gitstats_container'/gitstats'

echo "----------------------------------------------------------"
echo "Gitstats Usage: "
echo "                 cd" $gitstats_container"/gitstats"
echo "                 ./gitstats [git_project] [generate_file_folder]"
