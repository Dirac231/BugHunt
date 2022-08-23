paramdump(){
  echo -e "\nFETCHING INTERESTING PARAMETERS\n"
  cat $1 | gau | anew -q paramdump.txt
  cat paramdump.txt | unfurl format %q | cut -d "=" -f1 | sort -u | grep -v http | anew -q paramlist.txt
  cat paramdump.txt | grep -vE ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|swf|mp4|webm|JPG|wmv|flv)" | grep "?" | anew -q tmp; mv tmp paramdump.txt

  cat paramdump.txt | gf interestingparams | anew -q param_filtered.txt
  cat paramdump.txt | gf sqli | anew -q param_filtered.txt
  cat paramdump.txt | gf rce | anew -q param_filtered.txt
  cat paramdump.txt | gf ssrf | anew -q param_filtered.txt
  cat paramdump.txt | gf xss | anew -q param_filtered.txt
  cat paramdump.txt | gf lfi | anew -q param_filtered.txt

  echo -e "\nRESOLVING ALIVE PARAMETERS\n"
  rm paramdump.txt; cat param_filtered.txt | httpx -silent -fr -mc 200 -o tmp; mv tmp param_filtered.txt
  shuf param_filtered.txt > t; mv t param_filtered.txt

  echo -e "\nDISCOVERING UNLINKED GET / POST PARAMETERS\n"
  while read p; do x8 -u "$p" -L -w paramlist.txt; done < param_filtered.txt
  while read p; do x8 -X POST --as-body -u "$p" -L -w paramlist.txt; done < param_filtered.txt
}
