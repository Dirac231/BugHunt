## What is this
Three distinct nmap-based functions to perform port scanning and service enumeration, both on a single target and on a list of resolved domains

## How to use
You can call the ```tcp()``` and ```udp()``` functions on a single target like this
```bash
tcp [HOST]
udp [HOST]
```
You may need to install the ```vulscan``` project to perform a more fine discovery of vulnerabilities when using the tcp() function. \
 \
 The function ```bountyscan``` is to be called against a list of resolved subdomains, and it will portscan all non-web related services in verbose mode
 ```bash
 bountyscan [resolved.txt]
 ```
