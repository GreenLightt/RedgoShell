#! /bin/bash
#####################################################################
#   Goal: Scp Rsa File To Target Host So That Further Transfer
#         No Password
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
ssh_file='id_rsa_'$(date +%s%N)
ssh_folder=~/.ssh
url=''

##################################
# Function
##################################
function Usage() {
    echo "Usage: $(readlink -f $0) -t host "
    # exit status, 2 means Incorrect Usage
    exit 2
}

function GenerateSshFile() {
    echo 'Generate ssh file : '$ssh_folder'/'$ssh_file

    cd $ssh_folder
    ssh-keygen -t rsa -P '' -f $ssh_file
}

function DoSshConfig() {
    echo "
Host $url
     HostName $url
     User $USER
     PreferredAuthentications publickey
     IdentityFile ${ssh_folder}/${ssh_file}
" >> ~/.ssh/config
}

##################################
# Execute
##################################
if [ $# != 2 ]; then
    Usage
else
    while getopts t: option
    do
        case "$option" in
            t)
                echo 'Try ping host ...'
                CheckUrlValidate $OPTARG
                if [ $? -eq 0 ]; then
                    ssh_file='id_rsa_'$OPTARG
                    url=$OPTARG

                    GenerateSshFile
                    scp $ssh_folder'/'$ssh_file'.pub' $OPTARG':/tmp'
                    DoSshConfig
                    echo "Please execute the following command: "
                    echo "    cat /tmp/${ssh_file}.pub >> ~/.ssh/authorized_keys"
                else
                    echo 'Could not ping '$OPTARG
                fi
                ;;
            \?)
                Usage
                ;;
        esac
    done
fi
