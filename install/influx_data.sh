#! /bin/bash
#####################################################################
#   Goal: Build Monitor Tool
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

#############################
# Function
#############################
function Usage() {
    echo "Usage: $(readlink -f $0) -d desc_folder "
    # exit status, 2 means Incorrect Usage
    exit 2
}

##################################
# Execute
##################################
if [ $# != 2 ]; then
    Usage
else
    while getopts d: option
    do
        case "$option" in
            d)
                dest_folder=${OPTARG}
                ;;
            \?)
                Usage
                ;;
        esac
    done
fi

MakeFolderExist $dest_folder
cd $dest_folder

# telegraf v1.3.2
wget https://dl.influxdata.com/telegraf/releases/telegraf-1.3.2-1.x86_64.rpm
sudo yum -y localinstall telegraf-1.3.2-1.x86_64.rpm

# influxdb v1.2.4
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.2.4.x86_64.rpm
sudo yum -y localinstall influxdb-1.2.4.x86_64.rpm

# chronograf v1.3.2.1
wget https://dl.influxdata.com/chronograf/releases/chronograf-1.3.2.1.x86_64.rpm
sudo yum -y localinstall chronograf-1.3.2.1.x86_64.rpm

# kapacitor v1.3.1
wget https://dl.influxdata.com/kapacitor/releases/kapacitor-1.3.1.x86_64.rpm
sudo yum -y localinstall kapacitor-1.3.1.x86_64.rpm
