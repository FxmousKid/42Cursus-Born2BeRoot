# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: inazaria <inazaria@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/05/17 15:00:21 by inazaria          #+#    #+#              #
#    Updated: 2024/05/26 14:59:05 by inazaria         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# This is a Script that will be used to display information to the user about the system.

#!/bin/sh

ARCHITECTURE="$(uname -srvmo)"

PHYSICAL_CPU_COUNT=$(nproc)
VIRTUAL_CPU_COUNT=$(grep -c "^processor" /proc/cpuinfo)

TOTAL_MEMORY_MB=$(free -m | awk '{print $2}' | tr "\n" " " | awk '{print $2}')
CURRENT_MEMORY_USAGE_MB=$(free -m | awk '{print $3}' | tr "\n" " " | awk '{print $2}')
MEMORY_USAGE_PERCENTAGE=$(echo "scale=4;($CURRENT_MEMORY_USAGE_MB/$TOTAL_MEMORY_MB)*100" | bc | cut -c1-5)

TOTAL_DISK_SPACE_GB=$(df -h --total | grep total | awk '{print $2}' | tr -d "G")
CURRENT_DISK_SPACE_GB=$(df -h --total | grep total | awk '{print $3}' | tr -d "G")
DISK_SPACE_PERCENTAGE=$(df -h --total | grep total | awk '{print $5}' | tr -d "%")

CURRENT_CPU_USAGE_PERCENTAGE=$(ps -A -o pcpu | tail -n+2 | paste -sd+ | bc)

LAST_BOOT_DATE=$(who -b | awk '{print $3}')
LAST_BOOT_TIME=$(who -b | awk '{print $4}')


if [ $(lsblk | grep -ce "lvm") -eq 0 ]; then
	LVM_USE="no"
else
	LVM_USE="yes"
fi

TCP_CONNECTION_COUNT=$(grep -e "^TCP:" /proc/net/sockstat | awk '{print $3}')

USER_COUNT=$(w | awk '{print $4}' | xargs | awk '{print $1}')

IP_V4_ADDRESS=$(hostname -I)
MAC_ADDRESS=$(ifconfig -a | grep -e "ether" | awk '{print $2}')


SUDO_COUNT=$(grep -sce "COMMAND" /var/log/sudo/sudo_log)

wall "	<><><><><><><><><><><><><><>
		#Architecture: $ARCHITECTURE
		#CPU physical : $PHYSICAL_CPU_COUNT
		#vCPU : $VIRTUAL_CPU_COUNT
		#Memory Usage: $CURRENT_MEMORY_USAGE_MB/$TOTAL_MEMORY_MB MB ($MEMORY_USAGE_PERCENTAGE%)
		#Disk Usage: $CURRENT_DISK_SPACE_GB/$TOTAL_DISK_SPACE_GB GB ($DISK_SPACE_PERCENTAGE%)
		#CPU Load: $CURRENT_CPU_USAGE_PERCENTAGE%
		#Last boot: $LAST_BOOT_DATE $LAST_BOOT_TIME
		#LVM use: $LVM_USE
		#Connections TCP : $TCP_CONNECTION_COUNT ESTABLISHED
		#User log: $USER_COUNT
		#Network: IP $IP_V4_ADDRESS ($MAC_ADDRESS)
		#Sudo: $SUDO_COUNT cmd
		<><><><><><><><><><><><><><>"
