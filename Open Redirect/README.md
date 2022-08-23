## What is this
A function that implements the common workflow to discover unauthenticated open-redirect and CRLF vulnerabilities

## How to use?
You may call the function against a list of valid urls for maximum efficiency
```
redscan [URLs.txt]
```
it will alert you when vulnerabilities are found. Remember to specify your payload lists at the beginning of the file, in particular the ```google.txt``` list must reference the ```google.it``` domain
