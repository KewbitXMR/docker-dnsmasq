#!/bin/sh

# If the config file doesn't exist, create it
if [ ! -f /etc/dnsmasq.conf ]; then
  echo "log-queries" > /etc/dnsmasq.conf
  echo "no-resolv" >> /etc/dnsmasq.conf
fi

# If TOR_DNS_SERVER is set, update or add it for .onion domains
if [ -n "$TOR_DNS_SERVER" ]; then
    # Remove any old TOR DNS server configurations for .onion
    sed -i '/server=\/onion\//d' /etc/dnsmasq.conf
    # Add the new TOR DNS server configuration
    echo "server=/onion/$TOR_DNS_SERVER#9053" >> /etc/dnsmasq.conf
fi

# Ensure Cloudflare DNS is updated or added
sed -i '/server=1.1.1.1/d' /etc/dnsmasq.conf
echo "server=1.1.1.1" >> /etc/dnsmasq.conf

sed -i '/server=1.0.0.1/d' /etc/dnsmasq.conf
echo "server=1.0.0.1" >> /etc/dnsmasq.conf

# Start dnsmasq with the config file
dnsmasq --no-daemon --conf-file=/etc/dnsmasq.conf
