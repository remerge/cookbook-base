node.force_default['apt']['unattended_upgrades']['enable'] = true
node.force_default['apt']['unattended_upgrades']['remove_unused_dependencies'] = true

node.force_default['apt']['unattended_upgrades']['allowed_origins'] = [
  '${distro_id}:${distro_codename}',
  '${distro_id}:${distro_codename}-security',
  '${distro_id}:${distro_codename}-updates',
]

node.force_default['apt']['unattended_upgrades']['package_blacklist'] = [
  '^linux-.*tools-',
  '^linux-headers-',
  '^linux-image-',
  '^linux-modules-',
]

include_recipe 'ubuntu'
include_recipe 'apt'

apt_repository 'zenops-base' do
  uri 'http://ppa.launchpad.net/zenops/base/ubuntu'
  components ['main']
  distribution node['lsb']['codename']
  keyserver 'hkp://keyserver.ubuntu.com'
  key '84876BA9E328F8C5'
  action :add
end

package 'zenops-base'

cookbook_file '/etc/needrestart/needrestart.conf' do
  source 'needrestart.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/usr/sbin/lib_users' do
  source 'lib_users.py'
  owner 'root'
  group 'root'
  mode '0755'
end

template '/usr/sbin/attended-upgrade' do
  source 'attended-upgrade.sh'
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file '/usr/sbin/setup-network' do
  source 'setup-network'
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file '/usr/sbin/fix-fstab' do
  source 'fix-fstab'
  owner 'root'
  group 'root'
  mode '0755'
end

# cleanup some ubuntu cruft we don't need
purge_packages = %w(
  bind9
  bind9utils
  eatmydata
  geoip-database
  openipmi
  os-prober
  powermgmt-base
  snap-confine
  sshguard
  ubuntu-core-launcher
  xauth
  xdg-user-dirs
)

package purge_packages do
  action :purge
end

%w(
  /etc/skel/.profile
  /etc/apt/sources.list.d/proposed.list
).each do |f|
  file f do
    action :delete
  end
end
