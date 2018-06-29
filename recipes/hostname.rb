node.automatic_attrs['fqdn'] = node.name
node.automatic_attrs['hostname'] = node.name.split('.').first
node.automatic_attrs['domain'] = node.name.split('.')[1..-1].join('.')
node.automatic_attrs['ipaddress'] = node['public_ipv4']

include_recipe 'systemd::hostname'
