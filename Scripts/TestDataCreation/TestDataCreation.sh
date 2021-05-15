#!/bin/bash

#####################################################################
# Author        : Aatman Kothari                                    #
# Date          : 20/10/19                                          #
# Project       : Value add initiative (MDM-8062)		        #
# Purpose       : This script can be used to create test data by	# 
#				  placing the xml in same folder as script.			#
#																	#
#####################################################################

GREEN=$'\e[0;32m'
YELLOW=$'\e[1;33m'
NC=$'\e[0m'
CYAN=$'\e[0;36m'
RED=$'\e[0;31m'

StartTimestamp=`date +"%d-%m-%Y %T"`
STARTTIME=$(date +%s)
echo "${GREEN}Script started execution at${NC}: " $StartTimestamp

. TestDataCreation.properties

ls *.xml* &> /dev/null
if [ $? -eq 0 ]; then
	filename=$(ls *.xml*)
	
	filenamewithoutext=$(basename "$filename")
	fname="${filenamewithoutext%.*}"

	extwithoutfilename=$(basename "$filename")
	ext="${extwithoutfilename##*.}"
	
	mkdir Output/ &> /dev/null
	if [ "$(printf %s "$filename" | sed -n '$=')" -eq 1  ] 
	then
		echo "${YELLOW}How many XMLs do you need?${NC}"
		read filecount
		rm -rf Output/*
		for ((i=0; i<$filecount; i++))
		do
			cp $filename Output/$fname.$i.$ext
					
			randomGivenName=${GivenNames[RANDOM%${#GivenNames[@]}]}
			sed -i "s#<GivenNameOne>.*</GivenNameOne>#<GivenNameOne>${randomGivenName}</GivenNameOne>#g" Output/$fname.$i.$ext
			
			randomLastName=${LastNames[RANDOM%${#LastNames[@]}]}
			sed -i "s#<LastName>.*</LastName>#<LastName>${randomLastName}</LastName>#g" Output/$fname.$i.$ext
			
			randomBirthDate=${BithDates[RANDOM%${#BithDates[@]}]}
			sed -i "s#<BirthDate>.*</BirthDate>#<BirthDate>${randomBirthDate}</BirthDate>#g" Output/$fname.$i.$ext
			
			randomGender=${Genders[RANDOM%${#Genders[@]}]}
			sed -i "s#<GenderType>.*</GenderType>#<GenderType>${randomGender}</GenderType>#g" Output/$fname.$i.$ext
			
			randomNino=${Ninos[RANDOM%${#Ninos[@]}]}
			sed -i "s#<IdentificationNumber>.*</IdentificationNumber>#<IdentificationNumber>${randomNino}</IdentificationNumber>#g" Output/$fname.$i.$ext
			
			randomDate=${Dates[RANDOM%${#Dates[@]}]}
			sed -i "s#<ExpiryDate>.*</ExpiryDate>#<ExpiryDate>${randomDate}</ExpiryDate>#g" Output/$fname.$i.$ext
			
			randomDate=${Dates[RANDOM%${#Dates[@]}]}
			sed -i "s#<StartDate>.*</StartDate>#<StartDate>${randomDate}</StartDate>#g" Output/$fname.$i.$ext
			
			randomPolicyNumber=${PolicyNumbers[RANDOM%${#PolicyNumbers[@]}]}
			sed -i "s#<AdminContractId>.*</AdminContractId>#<AdminContractId>${randomPolicyNumber}</AdminContractId>#g" Output/$fname.$i.$ext
			
			randomSourcePartyId=${SourcePartyIds[RANDOM%${#SourcePartyIds[@]}]}
			sed -i "s#<AdminPartyId>.*</AdminPartyId>#<AdminPartyId>${randomSourcePartyId}</AdminPartyId>#g" Output/$fname.$i.$ext
			
			randomFirstAddressLine=${FirstAddressLines[RANDOM%${#FirstAddressLines[@]}]}
			sed -i "s#<AddressLineOne>.*</AddressLineOne>#<AddressLineOne>${randomFirstAddressLine}</AddressLineOne>#g" Output/$fname.$i.$ext
			
			randomSecondAddressLine=${SecondAddressLines[RANDOM%${#SecondAddressLines[@]}]}
			sed -i "s#<AddressLineTwo>.*</AddressLineTwo>#<AddressLineTwo>${randomSecondAddressLine}</AddressLineTwo>#g" Output/$fname.$i.$ext
			
			randomCounty=${Counties[RANDOM%${#Counties[@]}]}
			sed -i "s#<City>.*</City>#<City>${randomCounty}</City>#g" Output/$fname.$i.$ext
			
			randomPostCode=${PostCodes[RANDOM%${#PostCodes[@]}]}
			sed -i "s#<ZipPostalCode>.*</ZipPostalCode>#<ZipPostalCode>${randomPostCode}</ZipPostalCode>#g" Output/$fname.$i.$ext
			
		done
	else
		echo "More than 1 XML found. Exiting..."
		exit 1
	fi
else
    echo "Please place one xml in current directory."
fi

EndTimestamp=`date +"%d-%m-%Y %T"`
echo "${GREEN}Script ended execution at:${NC}" $EndTimestamp
ENDTIME=$(date +%s)
secs=$(($ENDTIME - $STARTTIME))
echo "${RED}Total duration:${NC}"
echo $((ENDTIME - STARTTIME)) | awk '{printf "%d:%02d:%02d", $1/3600, ($1/60)%60, $1%60}'