## What is this?
A number of tools to aid with subdomain enumeration and web services identification

## How to use?

- ```subscan [DOMAIN]``` will query passive sources to determine resolved subdomains and takeover opportunities from a single domain input.
- ```subbrute [DOMAIN]``` will DNS bruteforce a domain and use permutations to discover more hidden subdomains.
- ```subfuzz [DOMAIN]``` is a virtual host fuzzing procedure, that will potentially discover more hosts from a domain. Use this only against a resolved domain.
- ```subweb [RESOLVED.txt]``` will portscan the resolved subdomains and determine what web services and technologies are running. It will also use aquatone to perform screenshots
- ```paramdump [URLS.txt]``` will take a list of urls and dump all interesting and alive endpoints with parameters. It will then try to discover unlinked parameters using ```x8``` both in GET and POST requests
