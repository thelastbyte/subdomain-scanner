#!/bin/bash

# Subdomain enumeration script that uses recon-ng 

# input from command-line becomes domain to test
domain=$1
log_file=$2

#run as bash enumall.sh paypal.com

#timestamp
stamp=$(date +"%m_%d_%Y")
path=$(pwd)

#create rc file with workspace.timestamp and start enumerating hosts
touch $domain$stamp.resource

echo $domain

echo "workspaces select $domain$stamp" >> $domain$stamp.resource
echo "use recon/domains-hosts/baidu_site" >> $domain$stamp.resource
echo "set SOURCE $domain" >> $domain$stamp.resource
echo "run" >> $domain$stamp.resource
echo "use recon/domains-hosts/bing_domain_web" >> $domain$stamp.resource
echo "set SOURCE $domain" >> $domain$stamp.resource
echo "run" >> $domain$stamp.resource
echo "use recon/domains-hosts/google_site_web" >> $domain$stamp.resource
echo "set SOURCE $domain" >> $domain$stamp.resource
echo "run" >> $domain$stamp.resource
echo "use recon/domains-hosts/netcraft" >> $domain$stamp.resource
echo "set SOURCE $domain" >> $domain$stamp.resource
echo "run" >> $domain$stamp.resource
echo "use recon/domains-hosts/yahoo_domain" >> $domain$stamp.resource
echo "set SOURCE $domain" >> $domain$stamp.resource
echo "run" >> $domain$stamp.resource
echo "use recon/domains-hosts/google_site_api" >> $domain$stamp.resource
echo "set SOURCE $domain" >> $domain$stamp.resource
echo "run" >> $domain$stamp.resource
#echo "use recon/hosts/gather/dns/brute_hosts" >> $domain$stamp.resource
echo "use recon/domains-hosts/brute_hosts" >> $domain$stamp.resource
echo "set SOURCE $domain" >> $domain$stamp.resource
echo "run" >> $domain$stamp.resource
#echo "use recon/hosts/enum/dns/resolve" >> $domain$stamp.resource
echo "use recon/hosts-hosts/resolve" >> $domain$stamp.resource
echo "set SOURCE $domain" >> $domain$stamp.resource
echo "run" >> $domain$stamp.resource
echo "use reporting/csv" >> $domain$stamp.resource
#echo "set FILENAME $path/$domain_$stamp.csv" >> $domain$stamp.resource
echo "set FILENAME $path/$log_file" >> $domain$stamp.resource
echo "run" >> $domain$stamp.resource
echo "exit" >> $domain$stamp.resource
sleep 1

recon-ng --no-check -r $path/$domain$stamp.resource

exit
