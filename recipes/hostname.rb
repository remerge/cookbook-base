node.automatic_attrs['fqdn'] = node.name
node.automatic_attrs['hostname'] = node.name.split('.').first
node.automatic_attrs['domain'] = node.name.split('.')[1..-1].join('.')
node.automatic_attrs['ipaddress'] = node['public_ipv4']

file '/etc/hostname' do
  content "#{node['hostname']}\n"
  owner 'root'
  group 'root'
  mode '0644'
end

# we want to physically set the hostname in the compile phase
# as early as possible, just in case (although its not actually needed)
execute "hostname #{node['hostname']}" do
  action :nothing
  not_if { Mixlib::ShellOut.new('hostname').run_command.stdout.strip == node['hostname'] }
end.run_action(:run)

execute "domainname #{node['domain']}" do
  action :nothing
  not_if { Mixlib::ShellOut.new('domainname').run_command.stdout.strip == node['domain'] }
end.run_action(:run)

# for systems with cloud-init, ensure preserve hostname
# https://aws.amazon.com/premiumsupport/knowledge-center/linux-static-hostname-rhel7-centos7/
file '/etc/cloud/cloud.cfg.d/01_preserve_hostname.cfg' do
  content "preserve_hostname: true\n"
  only_if { ::File.exist?('/etc/cloud/cloud.cfg.d') }
end

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
