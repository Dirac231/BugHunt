subbrute(){
  echo -e "\nDNS BRUTING ROOT DOMAIN\n"
  wget https://raw.githubusercontent.com/BonJarber/fresh-resolvers/main/resolvers.txt -O resolvers.txt
  puredns bruteforce subdomains.txt $1 -r resolvers.txt -w tmp_puredns && cat tmp_puredns | anew -q resolved.txt && rm tmp_puredns

  echo -e "\nBRUTING WITH PERMUTATING DNS NAMES\n"
  gotator -sub resolved.txt -perm DNS_perm -depth 1 -numbers 10 -mindup -adv -md > permutated_DNS.txt
  puredns resolve permutated_DNS.txt -r resolvers.txt -w tmp_puredns;cat tmp_puredns | anew -q resolved.txt; rm tmp_puredns permutated_DNS.txt
}
