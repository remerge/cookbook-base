node.automatic_attrs['fqdn'] = node.name
node.automatic_attrs['hostname'] = node.name.split('.').first
node.automatic_attrs['domain'] = node.name.split('.')[1..-1].join('.')
node.automatic_attrs['ipaddress'] = node['public_ipv4']

include_recipe 'systemd::hostname'

# for systems with cloud-init, ensure preserve hostname
# https://aws.amazon.com/premiumsupport/knowledge-center/linux-static-hostname-rhel7-centos7/
file '/etc/cloud/cloud.cfg.d/01_preserve_hostname.cfg' do
  content "preserve_hostname: true\n"
  only_if { ::File.exist?('/etc/cloud/cloud.cfg.d') }
end
