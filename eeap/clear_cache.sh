#! /bin/bash
#####################################################################
#   Goal: Clear Cache After Changing Css Or Language File
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
php=/opt/bksite/php/bin/php
cache_file=/opt/eeap/htdocs/admin/cli/purge_caches.php

##################################
# Execute
##################################
$php $cache_file
