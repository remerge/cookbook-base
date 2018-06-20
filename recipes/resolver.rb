package "resolvconf"

# disable update of resolv.conf by dhclient
file "/etc/dhcp/dhclient-enter-hooks.d/resolvconf" do
  content "make_resolv_conf() { : ; }"
  only_if { ::File.exist?('/etc/dhcp/dhclient-enter-hooks.d') }
end

link "/etc/resolv.conf" do
  action :delete
  only_if { File.symlink?("/etc/resolv.conf") }
end

include_recipe 'resolver'

# additional static hosts
node['system']['static_hosts'].each do |ip, host|
  hostsfile_entry ip do
    ip_address ip
    hostname host
    priority 6
  end
end

my_region = node['ec2'] && node['ec2']['region']

cluster_search("*:*").each do |n| # rubocop:disable Metrics/BlockLength
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
