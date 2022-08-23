subfuzz(){
  domains=/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt
  len=$(curl -s -H "Host: IDONTEXIST.$1" http://$1 | wc -c)
  
  echo -e "\nFILTERING RESPONSES OF LENGTH $len\n"
  ffuf -c -w $domains -u http://$1 -H "Host: FUZZ.$1" -fs $len -mc 200
}
