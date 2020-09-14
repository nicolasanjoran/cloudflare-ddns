#!/bin/bash

export $(egrep -v '^#' .env | xargs)
echo "Checking the IP address for $CF_RECORD_NAME"

ip=`dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed s/\"//g`
lastip=`cat $HOME/.public_ip 2>/dev/null`

echo "Current IP: $ip"
echo "Last IP: $lastip"

ipv4_pattern="([0-9]{1,3}[\.]){3}[0-9]{1,3}"

if ! [[ $ip =~ $ipv4_pattern ]]; then
    echo "The current IPv4 address is invalid."
    exit 1
fi

if [ "$ip" != "$lastip" ]; then

    echo "The IP address has changed."
    
    curl --location --fail --request PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONEID/dns_records/$CF_RECORD_ID" \
    --header "X-Auth-Email: $CF_EMAIL" \
    --header "X-Auth-Key: $CF_KEY" \
    --header 'Content-Type: application/json' \
    --data-raw "{
    \"type\":\"A\",
    \"name\":\"$CF_RECORD_NAME\",
    \"content\":\"$ip\",
    \"ttl\":120,
    \"proxied\":true
    }"

    cloudflare_res=$?
    echo $cloudflare_res

    if [ $cloudflare_res == 0 ]; then
        echo $ip > $HOME/.public_ip
    else
        echo "Something went wrong while contacting Cloudflare."
    fi

    exit $cloudflare_res
fi
