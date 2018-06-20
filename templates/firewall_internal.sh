/sbin/iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT

<% @nodes.each do |n| %>
<% next unless n['public_ipv4'] %>
/sbin/iptables -A INPUT -s <%= n['public_ipv4'] %> -j ACCEPT
<% end %>
