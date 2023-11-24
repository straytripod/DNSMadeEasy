#!/bin/sh
#
# dddns-update.sh
#
# This script updates Dynamic DNS records on DNE Made Easy's
# DNS servers. You must have wget installed for this to work.
#
# This script is released as public domain in hope that it will
# be useful to others using DNS Made Easy. It is provided
# as-is with no warranty implied. Sending passwords as a part
# of an HTTP request is inherently insecure. I take no responsibilty
# if your password is discovered by use of this script.
#

# This is the e-mail address that you use to login
DMEUSER=<username>

# This is your DNS record password
DMEPASS=<password>

# This is the unique number for the record that you are updating.
# This number can be obtained by clicking on the DDNS link for the
# record that you wish to update; the number for the record is listed
# on the next page.
DMEID=<dns-record-id>

# Obtain current ip address
# uncomment below for public facing server / router with dynmic IP
    #CIPADDR=`ifconfig eth0 | grep inet | awk '{print $2}' | awk -F : '{print $2}'`
# comment below for public facing server / router with dynmic IP   
    CIPADDR=$(curl -s http://myip.dnsmadeeasy.com)

# Check Public IP address
IPLOG='./Log/currentip.txt' #File Location
CHLOG='./Log/change.log'  #File Location
# Check ip currentip.txt does not exists
if [ ! -f "$IPLOG" ]; then
mkdir ./Log && touch $IPLOG
fi
OIP=$(cat $IPLOG) # grab the last IP recorded

if [ "$OIP" = "$CIPADDR" ]; then 
	exit 1 #do nothing
# update the log
	else date > $CHLOG && echo "Changing the records IP address to: $CIPADDR" >> $CHLOG && echo $CIPADDR > $IPLOG &&
# update the record
		if wget -q -O /proc/self/fd/1 https://cp.dnsmadeeasy.com/servlet/updateip?username=$DMEUSER\&password=$DMEPASS\&id=$DMEID\&ip=$CIPADDR | grep success > /dev/null; then
		echo "DNS Record Updated Successfully"  >> $CHLOG
		else
		echo "There was a Problem updating DNS record."  >> $CHLOG
		fi
# copy the update record section below to change more records. you will need adjust the var accordingly.
fi
