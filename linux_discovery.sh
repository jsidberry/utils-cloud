#!/bin/bash
#
# Sample shell script to discover web-servers
#

# heading
echo "Linux Discovery Report" > services.out

# hostname
echo "" >> services.out
echo "------------------" >> services.out
echo "Server/Domain_Name" >> services.out
echo "------------------" >> services.out
hostname >> services.out
hostname --fqdn >> services.out
cat /proc/sys/kernel/hostname >> services.out

# get OS Level
echo "" >> services.out
echo "--------" >> services.out
echo "OS Level" >> services.out
echo "--------" >> services.out
egrep '^(VERSION|NAME)=' /etc/os-release >> services.out
VER=$(egrep '^(NAME)=' /etc/os-release)

# get IP ADDRESSES
echo "" >> services.out
echo "------------" >> services.out
echo "IP Addresses" >> services.out
echo "------------" >> services.out
if [[ $VER == *"Red"* ]]; then
    iptemp=$(ip addr show eth0 | grep -i "inet ")
    ip=$(echo $iptemp | awk '{print $2}')
else
    ip=$(ifconfig | grep -B1 inet)
fi
echo $ip >> services.out

# get WEB SERVERS
echo "" >> services.out
echo "-----------" >> services.out
echo "Web Servers" >> services.out
echo "-----------" >> services.out
## array of popular web-servers
web_servers=("nginx" "apache" "apache2")

for i in "${web_servers[@]}"
do
    echo $(ps aux | grep $i | grep -v grep | wc -l) $i >> services.out
done

# get LIST of SERVICES
echo "" >> services.out
echo "----------------------------------------" >> services.out
echo "List of services using systemctl command" >> services.out
echo "----------------------------------------" >> services.out
systemctl list-units --type=service >> services.out

echo "" >> services.out
echo "--------------------------------------" >> services.out
echo "List of services using service command" >> services.out
echo "--------------------------------------" >> services.out
service --status-all >> services.out

# get PORT ALLOCATION
echo "" >> services.out
echo "-----------------------------" >> services.out
echo "Port Allocation using netstat" >> services.out
echo "-----------------------------" >> services.out
if [[ $VER == *"Red"* ]]; then
    ss >> services.out
else
    netstat -punta >> services.out
fi

# get CPU info
echo "" >> services.out
echo "--------" >> services.out
echo "CPU info" >> services.out
echo "--------" >> services.out
lscpu >> services.out
egrep '^(VERSION|NAME)=' /etc/os-release >> services.out

# get MEMORY info
echo "" >> services.out
echo "-----------" >> services.out
echo "MEMORY info" >> services.out
echo "-----------" >> services.out
lsmem >> services.out
echo "" >> services.out
cat /proc/meminfo | grep Mem >> services.out

# get DISK info
echo "" >> services.out
echo "---------" >> services.out
echo "DISK info" >> services.out
echo "---------" >> services.out
lsblk >> services.out

# get Hardware info
echo "" >> services.out
echo "-------------" >> services.out
echo "HARDWARE info" >> services.out
echo "-------------" >> services.out
sudo lshw >> services.out



