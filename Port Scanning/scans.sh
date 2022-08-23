tcp(){
  echo -e "\nTCP SCAN\n"
  sudo nmap -p- -Pn -sC -sV -v --min-rate 800 --open --reason $1 -o tcp_$1.txt
  ports=$(cat tcp_$1.txt | grep "^[0-9]" | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$// | awk '{print $1}')
  sudo rm tcp_$1.txt

  echo -e "\nTCP VULN SCANNING\n"
  sudo nmap -p$ports -Pn -sV --script="vuln and not (vulners)",vulscan/vulscan.nse --script-args vulscandb=scipvuldb.csv $1
}

udp(){
  echo -e "\nUDP TOP 2000 SCAN\n"
  sudo nmap -sUV -Pn -v --version-intensity 0 --top-ports 2000 --scan-delay 950ms --open --reason $1

  echo -e "\nFULL UDP SCAN\n"
  sudo nmap -sUV -Pn -v --version-intensity 0 -p- --scan-delay 950ms --open --reason $1
}

bountyscan(){
  echo -e "\nTCP SCANNING THE DOMAINS\n"
  sudo nmap -Pn --min-rate 800 --scan-delay 950ms --open --reason -v --top-ports 8351 --exclude-ports 80,443,8080,8000,8192,3000 -sCV -iL $1

  echo -e "\nUDP SCANNING THE DOMAINS\n"
  sudo nmap -sUV -Pn -v --version-intensity 0 -p- --scan-delay 950ms --open --reason -iL $1
}
