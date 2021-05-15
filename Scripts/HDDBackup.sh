#!/bin/bash

#####################################################################
# Author        : Aatman Kothari                                    #
# Date          : 16/03/21                                          #
# Project       : Hard Disk Backup         		                    #
# Purpose       : Take automated incremental backups                #
#																	#
#####################################################################

GREEN='\e[0;32m'
YELLOW='\e[1;33m'
NC='\e[0m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

StartTimestamp=`date +"%d-%m-%Y %T"`
curr_dt=`date +"%d.%m.%Y_%H.%M.%S"`

Source="/d /e /f /g /h"
echo -n "Input destination drive letter:"
read -e Destination
echo $Destination

select Drive in $Source; do
	if [[ $Drive = '/d' ]] || [[ $Drive = '/e' ]] || [[ $Drive = '/f' ]] || [[ $Drive = '/g' ]] || [[ $Drive = '/h' ]] ; then
		CopyFrom=$Drive/
		CopyTo=/$Destination/Backup/
		echo -e "${RED}FROM:${NC}" $CopyFrom "${GREEN}TO:${NC}" $CopyTo
		#Preserve, unique, recursive, verbose.
		cp -purv $CopyFrom $CopyTo >> Copy_$curr_dt.log
		break
	elif [[ $opt = 'No' ]] ; then
		break
		echo -e "${RED}Please enter correct drive number.${NC}"
	fi
done
echo -e "${PURPLE}Copying started at: ${NC}" $StartTimestamp
echo -e "${GREEN}Copying complete${NC}. Please check log file at" ${GREEN}`pwd`${NC}
EndTimestamp=`date +"%d-%m-%Y %T"`
echo -e "${PURPLE}Copying ended at: ${NC}" $EndTimestamp
