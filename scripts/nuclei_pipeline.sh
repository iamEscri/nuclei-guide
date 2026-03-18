#!/bin/bash

TARGET=$1

subfinder -d $TARGET > subdomains.txt
httpx -l subdomains.txt > alive.txt
nuclei -l alive.txt -severity medium,high,critical -stats
