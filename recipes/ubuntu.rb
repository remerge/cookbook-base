include_recipe "ubuntu"
include_recipe "apt"

package "needrestart"

cookbook_file "/etc/needrestart/needrestart.conf" do
  source "needrestart.conf"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/usr/sbin/lib_users" do
  source "lib_users.py"
  owner "root"
  group "root"
  mode "0755"
end

template "/usr/sbin/attended-upgrade" do
  source "attended-upgrade.sh"
  owner "root"
  group "root"
  mode "0755"
end

cookbook_file "/usr/sbin/setup-network" do
  source "setup-network"
  owner "root"
  group "root"
  mode "0755"
end

cookbook_file "/usr/sbin/fix-fstab" do
  source "fix-fstab"
  owner "root"
  group "root"
  mode "0755"
end

# cleanup some ubuntu cruft we don't need
purge_packages = %w(
  apport
  apport-symptoms
  bcache-tools
  bind9
  bind9utils
  btrfs-tools
  byobu
  cryptsetup
  cryptsetup-bin
  eatmydata
  fonts-ubuntu-font-family-console
  geoip-database
  gir1.2-glib-2.0
  open-iscsi
  open-vm-tools
  openipmi
  os-prober
  overlayroot
  pastebinit
  policykit-1
  powermgmt-base
  python3-gi
  screen
  snap-confine
  snapd
  software-properties-common
  sosreport
  sshguard
  ubuntu-core-launcher
  xauth
  xdg-user-dirs
  xfsprogs
  zerofree
)

package purge_packages do
  action :purge
end

%w(
  google-accounts-daemon
  mdadm
  smartd
).each do |svc|
  service svc do
    action [:stop, :disable]
  end
end

%w(
  /etc/skel/.profile
  /etc/init.d/mdadm
  /etc/apt/sources.list.d/proposed.list
).each do |f|
  file f do
    action :delete
  end
end

package "ubuntu-minimal"
package "ubuntu-standard"
