#!/bin/bash

# Set proxies for school server so you can use wget, git clone, etc.
proxy="149.89.1.30:3128"
export http_proxy=$proxy
export https_proxy=$proxy
export ftp_proxy=$proxy
export scp_proxy=$proxy

printf "\033[1;32mProxies successfully set!\n"
