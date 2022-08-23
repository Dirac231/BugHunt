subscan(){
  echo -e "\nPASSIVE SOURCE ENUMERATION\n"
  amass enum -passive -d $1 | anew -q subdomains
  subfinder -d $1 | anew -q subdomains
  assetfinder --subs-only $1 | anew -q subdomains
  findomain -quiet -t $1 | anew -q subdomains; rm iet
  github-subdomains -d $1 -t GIT_TOKEN_FILE -q -raw; cat $1.txt | anew -q subdomains; rm $1.txt
  echo $1 | gau | unfurl -u domains | anew -q subdomains
  curl -s "https://api.hackertarget.com/hostsearch/?q=$1" | cut -f 1 -d , | anew -q subdomains
  curl -s "https://crt.sh/?q=%.$1" > /tmp/curl.out; cat /tmp/curl.out | grep $1 | grep TD | sed -e 's/<//g' | sed -e 's/>//g' | sed -e 's/TD//g' | sed -e 's/\///g' | sed -e 's/ //g' | sed -n '1!p' | sort -u | anew -q subdomains
  curl -s "https://riddler.io/search/exportcsv?q=pld:$1" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | anew -q subdomains
  curl -s "https://jldc.me/anubis/subdomains/$1" | jq -r '.' | grep -o "\w.*$1" | sort -u | anew -q subdomains
  while read p
  do
    curl -s "https://riddler.io/search/exportcsv?q=pld:$p" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | anew -q subdomains
    curl -s "https://api.hackertarget.com/hostsearch/?q=$1" | cut -f 1 -d , | anew -q subdomains
    curl -s "https://jldc.me/anubis/subdomains/$p" | jq -r '.' | grep -o "\w.*$1" | sort -u | anew -q subdomains
  done < subdomains
  
  echo -e "\nRESOLVING OF PASSIVE SOURCE DATA\n"
  wget https://raw.githubusercontent.com/BonJarber/fresh-resolvers/main/resolvers.txt -O resolvers.txt
  puredns resolve subdomains -r resolvers.txt -w tmp_puredns; cat tmp_puredns | anew -q resolved.txt; rm tmp_puredns
  
  echo -e "\nSUBDOMAIN TAKEOVER ISSUES\n"
  sudo docker run -v $(pwd):/etc/dnsreaper punksecurity/dnsreaper file --filename /etc/dnsreaper/subdomains
  subjack -w subdomains -a | tee -a takeover.txt | grep -v "Vulnerable"
  
  echo -e "\nSUBDOMAINS FROM SSL CERTIFICATES\n"
  while read p; do cero $p | sed 's/^*.//' | grep -e "\." | grep $1 | anew -q resolved.txt; done < resolved.txt
  touch analytic; while read url; do python3 analyticsrelationships.py -u $url >> analytic; done < resolved.txt && cat analytic | grep $1 | cut -d ' ' -f 2 | anew -q resolved.txt
}
