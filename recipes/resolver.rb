package 'resolvconf'

# disable update of resolv.conf by dhclient
file '/etc/dhcp/dhclient-enter-hooks.d/resolvconf' do
  content 'make_resolv_conf() { : ; }'
  only_if { ::File.exist?('/etc/dhcp/dhclient-enter-hooks.d') }
end

link '/etc/resolv.conf' do
  action :delete
  only_if { File.symlink?('/etc/resolv.conf') }
end

node.force_default['resolver']['options']['timeout'] = 1
node.force_default['resolver']['options']['attempts'] = 5
node.force_default['resolver']['options']['rotate'] = nil
node.force_default['resolver']['nameservers'] = [
  '8.8.8.8',
  '8.8.4.4',
]

include_recipe 'resolver'

hostsfile_entry '127.0.1.1' do
  ip_address '127.0.1.1'
  action :remove
end

hostsfile_entry '127.0.0.1' do
  ip_address '127.0.0.1'
  hostname 'localhost'
end

ipv6_hosts = [
  { ip: '::1', name: 'ip6-localhost', aliases: %w(ip6-loopback) },
  { ip: 'fe00::0', name: 'ip6-localnet' },
  { ip: 'ff00::0', name: 'ip6-mcastprefix' },
  { ip: 'ff02::1', name: 'ip6-allnodes' },
  { ip: 'ff02::2', name: 'ip6-allrouters' },
]

ipv6_hosts.each do |host|
  hostsfile_entry host[:ip] do
    ip_address host[:ip]
    hostname host[:name]
    aliases host[:aliases] if host[:aliases]
    priority 5
  end
end

node['system']['static_hosts'].each do |ip, host|
  hostsfile_entry ip do
    ip_address ip
    hostname host
    priority 6
  end
end

my_region = node['ec2'] && node['ec2']['region']

cluster_search('*:*').each do |n| # rubocop:disable Metrics/BlockLength
  region = n['ec2'] && n['ec2']['region']

  if n['local_ipv4'] && my_region == region
    hostsfile_entry "local_ipv4_#{n['fqdn']}" do
      ip_address n['local_ipv4']
      hostname lazy { n['fqdn'] }
      aliases [n['hostname']]
      action :create
    end

    if n['public_ipv4']
      hostsfile_entry "public_ipv4_#{n['fqdn']}" do
        ip_address n['public_ipv4']
        hostname lazy { n['fqdn'] }
        aliases [n['hostname']]
        action :remove
      end
    end

    if n['public_ipv6']
      hostsfile_entry "public_ipv6_#{n['fqdn']}" do
        ip_address n['public_ipv6']
        hostname lazy { n['fqdn'] }
        aliases [n['hostname']]
        action :remove
      end
    end
  else
    if n['public_ipv4']
      hostsfile_entry "public_ipv4_#{n['fqdn']}" do
        ip_address n['public_ipv4']
        hostname lazy { n['fqdn'] }
        aliases [n['hostname']]
        action :create
      end

      if n['local_ipv4']
        hostsfile_entry "local_ipv4_#{n['fqdn']}" do
          ip_address n['local_ipv4']
          hostname lazy { n['fqdn'] }
          aliases [n['hostname']]
          action :remove
        end
      end
    end

    if n['public_ipv6']
      hostsfile_entry "public_ipv6_#{n['fqdn']}" do
        ip_address n['public_ipv6']
        hostname lazy { n['fqdn'] }
        aliases [n['hostname']]
        action :create
      end
    end
  end
end
