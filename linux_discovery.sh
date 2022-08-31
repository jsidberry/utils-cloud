#!/bin/bash
#
# Sample shell script to discover web-servers
#
eval "serveroutputfile=services_$HOSTNAME.out"

# heading
echo "Linux Discovery Report" > $serveroutputfile
echo $serveroutputfile >> $serveroutputfile

# hostname
echo "" >> $serveroutputfile
echo "------------------" >> $serveroutputfile
echo "Server/Domain_Name" >> $serveroutputfile
echo "------------------" >> $serveroutputfile
hostname >> $serveroutputfile
hostname --fqdn >> $serveroutputfile
cat /proc/sys/kernel/hostname >> $serveroutputfile

# get OS Level
echo "" >> $serveroutputfile
echo "--------" >> $serveroutputfile
echo "OS Level" >> $serveroutputfile
echo "--------" >> $serveroutputfile
egrep '^(VERSION|NAME)=' /etc/os-release >> $serveroutputfile
VER=$(egrep '^(NAME)=' /etc/os-release)

# get IP ADDRESSES
echo "" >> $serveroutputfile
echo "------------" >> $serveroutputfile
echo "IP Addresses" >> $serveroutputfile
echo "------------" >> $serveroutputfile
if [[ $VER == *"Red"* ]]; then
    iptemp=$(ip addr show eth0 | grep -i "inet ")
    ip=$(echo $iptemp | awk '{print $2}')
else
    ip=$(ifconfig | grep -B1 inet)
fi
echo $ip >> $serveroutputfile

# get WEB SERVERS
echo "" >> $serveroutputfile
echo "-----------" >> $serveroutputfile
echo "Web Servers" >> $serveroutputfile
echo "-----------" >> $serveroutputfile
## array of popular web-servers
web_servers=("nginx" "apache" "apache2")

for i in "${web_servers[@]}"
do
    echo $(ps aux | grep $i | grep -v grep | wc -l) $i >> $serveroutputfile
done

# get LIST of SERVICES
echo "" >> $serveroutputfile
echo "----------------------------------------" >> $serveroutputfile
echo "List of services using systemctl command" >> $serveroutputfile
echo "----------------------------------------" >> $serveroutputfile
systemctl list-units --type=service >> $serveroutputfile

echo "" >> $serveroutputfile
echo "--------------------------------------" >> $serveroutputfile
echo "List of services using service command" >> $serveroutputfile
echo "--------------------------------------" >> $serveroutputfile
service --status-all >> $serveroutputfile

# get PORT ALLOCATION
echo "" >> $serveroutputfile
echo "-----------------------------" >> $serveroutputfile
echo "Port Allocation using netstat" >> $serveroutputfile
echo "-----------------------------" >> $serveroutputfile
if [[ $VER == *"Red"* ]]; then
    ss >> $serveroutputfile
else
    netstat -punta >> $serveroutputfile
fi

# get CPU info
echo "" >> $serveroutputfile
echo "--------" >> $serveroutputfile
echo "CPU info" >> $serveroutputfile
echo "--------" >> $serveroutputfile
lscpu >> $serveroutputfile
egrep '^(VERSION|NAME)=' /etc/os-release >> $serveroutputfile

# get MEMORY info
echo "" >> $serveroutputfile
echo "-----------" >> $serveroutputfile
echo "MEMORY info" >> $serveroutputfile
echo "-----------" >> $serveroutputfile
lsmem >> $serveroutputfile
echo "" >> $serveroutputfile
cat /proc/meminfo | grep Mem >> $serveroutputfile

# get DISK info
echo "" >> $serveroutputfile
echo "---------" >> $serveroutputfile
echo "DISK info" >> $serveroutputfile
echo "---------" >> $serveroutputfile
lsblk >> $serveroutputfile

# get Hardware info
echo "" >> $serveroutputfile
echo "-------------" >> $serveroutputfile
echo "HARDWARE info" >> $serveroutputfile
echo "-------------" >> $serveroutputfile
lshw >> $serveroutputfile

# get USERS info
echo "" >> $serveroutputfile
echo "-------------" >> $serveroutputfile
echo "USERS info" >> $serveroutputfile
echo "-------------" >> $serveroutputfile
cat /etc/passwd >> $serveroutputfile

# get GROUPS info
echo "" >> $serveroutputfile
echo "-------------" >> $serveroutputfile
echo "GROUPS info" >> $serveroutputfile
echo "-------------" >> $serveroutputfile
cat /etc/group >> $serveroutputfile

# get CURRENT RUNNING STATE processes info
echo "" >> $serveroutputfile
echo "-------------" >> $serveroutputfile
echo "PROCESSES info" >> $serveroutputfile
echo "-------------" >> $serveroutputfile
ps aux >> $serveroutputfile
