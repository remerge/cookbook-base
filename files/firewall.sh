#!/bin/bash

# default policies
/sbin/iptables -P INPUT DROP
/sbin/iptables -P FORWARD ACCEPT
/sbin/iptables -P OUTPUT ACCEPT

/sbin/iptables -t nat -P PREROUTING ACCEPT
/sbin/iptables -t nat -P OUTPUT ACCEPT
/sbin/iptables -t nat -P POSTROUTING ACCEPT

/sbin/iptables -t mangle -P PREROUTING ACCEPT
/sbin/iptables -t mangle -P INPUT ACCEPT
/sbin/iptables -t mangle -P FORWARD ACCEPT
/sbin/iptables -t mangle -P OUTPUT ACCEPT
/sbin/iptables -t mangle -P POSTROUTING ACCEPT

# cleanup
/sbin/iptables -F
/sbin/iptables -t nat -F
/sbin/iptables -t mangle -F

/sbin/iptables -X
/sbin/iptables -t nat -X
/sbin/iptables -t mangle -X

/sbin/iptables -Z
/sbin/iptables -t nat -Z
/sbin/iptables -t mangle -Z

# allow loopback interface to do anything
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A OUTPUT -o lo -j ACCEPT

# ICMP
/sbin/iptables -A INPUT -p icmp --icmp-type 3 -j ACCEPT
/sbin/iptables -A INPUT -p icmp --icmp-type 4 -j ACCEPT
/sbin/iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
/sbin/iptables -A INPUT -p icmp --icmp-type 11 -j ACCEPT
/sbin/iptables -A INPUT -p icmp --icmp-type 12 -j ACCEPT

# allow incoming connections related to existing allowed connections
/sbin/iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# allow incoming SSH connections
/sbin/iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT

# run custom firewall rules
for i in /etc/firewall.d/*; do
	if [[ -r ${i} ]]; then
		source ${i}
	fi
done

exit 0
