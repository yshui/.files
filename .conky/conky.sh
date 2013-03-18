#!/bin/dash -f 
wmiir read /rbar/conky > /dev/null
if [ $? -eq 0 ]; then
       wmiir remove /rbar/conky
       sleep 2
fi       
echo '' | wmiir create /rbar/conky
conky-cli -c ~/.conky-clirc | ~/.conky/conky_write.pl

