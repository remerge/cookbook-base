#!/bin/bash

if [[ $1 == "-y" ]]; then
	export DEBIAN_FRONTEND=noninteractive
fi

xapt() {
	if [[ $DEBIAN_FRONTEND == "noninteractive" ]]; then
		apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" "$@"
	else
		apt-get "$@"
	fi
}

# cleanup old apt-get processes hanging around
kill $(pidof apt-get)

xapt update
xapt dist-upgrade
xapt dist-upgrade || exit 1
<% if lxc? %>
xapt purge linux-image-* linux-headers-* linux-tools-* linux-modules-* grub-common
rm -rf /boot/grub
<% else %>
xapt install linux-{image,headers,tools}-generic-hwe-16.04-edge || exit 1
xapt purge $(dpkg -l | egrep 'linux-(image|headers|tools)-4.4.0' | awk '{print $2}')
<% end %>
xapt autoremove
xapt purge $(dpkg -l | grep ^rc | awk '{print $2}') || exit 1

chef-client
chef-client || exit 1
