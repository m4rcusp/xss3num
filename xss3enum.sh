#!/bin/bash

. ~/.profile

echo "Insert a target:"
read host
echo "Insert your bug bounty program name and your username:"
echo "ex: hackerone:h4cker"
read username
echo "insert the params.txt wordlist path"
read path
echo "Looking for subdomains..."
subfinder -d $host | anew subf
echo "$host" | haktrails subdomains | anew haktrails1
assetfinder $host | anew assetf
/root/bounty/subdom/findomain -t $host -q | anew findomain1
amass enum -d $host | anew amass1
echo "Deleting duplicates..."
cat * | anew domains
echo "Done!"
echo "Validating domains..."
httpx -l domains -H "$username" -mc 200 -timeout 3 -silent -threads 1000 | anew httpx1
echo "Done!"
echo "Looking for parameters..."
rush -i httpx1 'python3 /root/bounty/subdom/ParamSpider/paramspider.py -d {}'
cat output/http:/* output/https:/* | anew xss
echo "Validating..."
anti-burl xss | anew xss1
echo "Done!"
echo "Injecting payload into the parameters..."
cat xss1 | cut -d " " -f9 | dalfox pipe --mining-dict-word $path --skip-bav -o resultxss
echo "Done!"
