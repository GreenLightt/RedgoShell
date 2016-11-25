#! /bin/bash
#####################################################################
#   Goal: Auto Complete Git Command In Shell Environment
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
completion_file="git-completion.bash"
bashrc_path="/root/.bashrc"
cur_path=$(cd "$(dirname "$0")"; pwd)
exec_command="source "$cur_path"/resources/"$completion_file

##################################
# Execute
##################################
# Validate completion_file Exist Or Not
CheckFileExist $cur_path"/resources/"$completion_file

# Validate Command Exist Or Not
grep_result=$(grep "$exec_command" $bashrc_path | wc -l)

if [ $grep_result -eq 0 ]; then
    echo "" >> $bashrc_path
    echo "# auto complete git command" >> $bashrc_path
    echo $exec_command >> $bashrc_path
fi
