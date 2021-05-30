#!/bin/sh

# List of ports you want to allow. To allow all ports, set to empty string
# The port list must conform to the syntax described in the ufw man page

# PORT_LIST=''  #Allow all ports
PORT_LIST='443'

curl -s https://www.cloudflare.com/ips-v4 -o /tmp/cf_ips
curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cf_ips

if [[ -n ${PORT_LIST} ]]; then
  # Allow traffic from Cloudflare IPs restricted to specified ports
  while read CFIP; do
    ufw allow proto tcp from ${CFIP} to any port ${PORT_LIST} comment 'Cloudflare IP'
  done < /tmp/cf_ips

else
  # Allow all traffic from Cloudflare IPs (no ports restriction)
  while read CFIP; do
    ufw allow proto tcp from ${CFIP} comment 'Cloudflare IP'
  done < /tmp/cf_ips
fi

ufw reload > /dev/null
