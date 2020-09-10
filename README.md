# cloudflare-ddns

This lightweight script can be used to programatically (and periodically) update a Cloudflare DNS record based on your public IPv4 address.
Please note that this isn't tested for IPv6, which is disabled on my ISP router.

## How-to

1. Edit the .env-placeholder file to add your cloudflare details.

```
CF_EMAIL=<Cloudflare email here>
CF_KEY=<Your API Key>
CF_ZONEID=<The zone Id> # You can retrieve it using the Cloudflare API
CF_RECORD_ID=<The record id> # You can retrieve it using the Cloudflare API
CF_RECORD_NAME=<The record name, for example 'www'>
```

2. Rename the `.env-placeholder` file to `.env`
3. Run the script.

