#!/bin/bash

ips=(10.242.172.176 10.65.243.61)
errors=()
count=0

from_dir="~"
from_file="test.txt"

to_dir="/tmp"
to_file="text.txt"

pushd ${from_dir}

for ip in ${ips[@]}; do
    printf "\nSCP into : ${ip}\n"
    echo   "---------------------"

    scp -o ConnectTimeout=1 -o ConnectionAttempts=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  ${from_file} xxxx@${ip}:${to_dir}
    ssh -t -t -o ConnectTimeout=1 -o ConnectionAttempts=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null xxxx@${ip} <<CMD
sudo su -
cd ${to_dir}
rm -rf "${to_file}_bak"
exit
exit
CMD

    [[ $? != 0 ]] && echo "###### ERROR. Can't SCP into ${ip}" && errors+=(${ip})
    printf "\n**************************************\n"

    count=$((count+1))

done

echo "Total Servers : ${count}"
err=$( IFS=$','; echo "${errors[*]}" )
echo "Errors : ${err}"