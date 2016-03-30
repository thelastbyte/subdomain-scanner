# Domain scanner using Kali 2.0  
# It runs multiple domain scanner such as fierce, theharvester and recon-ng and creates
# one final list of subdomain for given domain.

domain=$1 
#base_domain_list=$2

#timestamp
stamp=$(date +"%m_%d_%Y")
path=$(pwd)

if [ -z "$1" ] 
then 
   echo "\n Usages : scanner.sh example.com"
   exit
fi

#########################################################################
#   Function to extract domain from fierece logs
#########################################################################
extract_domains_from_fierce()
{
 echo "\n Extracting domain data from fierece ${fierce_log} file " 

 # Extract data and store it in temp file 
 awk '/Now\ performing/ {flag=1;next} /Subnets\ found/{flag=0} flag {print} ' ${fierce_log} | awk -F' ' '{print $2}' > ${fierce_temp_log} 

 echo "\n Done with formatting ${fierce_log} file"
}


#########################################################################
#   Function to extract domain from fierece logs
#########################################################################
extract_domains_from_theharvester()
{
 echo "\n Extracting domain data from fierece $theharvester_log file " 

 awk '/\[\-\]\ Resolving\ hostnames/ {flag=1;next} /\[\+\]\ Starting\ active\ queries:/{flag=0} flag {print} ' ${theharvester_log} | awk -F':' '{print $2}' > ${theharvester_temp_log}

 echo "\n Done with formating ${theharvester_log} file"
}

#########################################################################
#   Function to extract domain from fierece logs
#########################################################################
extract_domains_from_recon()
{
 echo "\n Extracting domain data from fierece $recon_log file " 
 awk -F',' '{ print $1}' ${recon_log}  | tr -d '"' > ${recon_temp_log}
 echo "\n Done with formating ${recon_log} file"
}

#########################################################################
#   Function to extract domain from fierece logs
#########################################################################
create_domain_list()
{
  echo "\n Creating combined subdomain list for $domain"
  cat ${theharvester_temp_log} >> ${recon_temp_log}
  cat ${fierce_temp_log} >> ${recon_temp_log}
  sort -f ${recon_temp_log} | uniq >  ${subdomain_log}
  echo "\n Finished creating subdomain list"
}



####################### Main Start ######################################

# Final subdomain list
subdomain_log="${domain}_subdomains_${stamp}.txt"

# Run the fierce scan
fierce_log="${domain}_fierce_scan_${stamp}.txt"
fierce_temp_log="${domain}_fierce_scan_${stamp}.tmp"
echo "fierce log = $fierce_log "
/usr/bin/fierce -dns ${domain} -file $fierce_log

# Run the harvester 
theharvester_log="${domain}_theharvester_scan_${stamp}.txt"
theharvester_temp_log="${domain}_theharvester_scan_${stamp}.tmp"
/usr/bin/theharvester -d ${domain} -b all -n -t > $theharvester_log 

# Run jhaddix's enumall using recong
recon_log="${domain}_recon_scan_${stamp}.csv"
recon_temp_log="${domain}_recon_scan_${stamp}.tmp"
sh enumall-jhaddix.sh ${domain} ${recon_log} 

#Extract domain names from each of log file
extract_domains_from_fierce
extract_domains_from_theharvester
extract_domains_from_recon

#Combine all the logs, remove duplicates and sort the file alpabetically
create_domain_list

echo "\n Finished"
