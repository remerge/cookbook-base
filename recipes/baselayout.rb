# ensure that system users/groups from baselayout are always correct
# (just in case somebody has given login shells to system accounts etc)
node[:baselayout][:groups].each do |name, params|
  group name do
    gid params[:gid]
    append true if params[:append]
    members params[:members].split(',')
  end
end

node[:baselayout][:users].each do |name, params|
  comment = params[:comment] || name

  user name do
    password '*'
    uid params[:uid]
    gid params[:gid]
    comment comment
    home params[:home]
    shell params[:shell]
  end
end

user 'root' do
  uid 0
  gid 0
  comment 'root'
  home '/root'
  shell '/bin/bash'
end

%w(/root /root/.ssh).each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode '0700'
  end
end

# force sane permissions on directories
%w(
  /bin
  /boot
  /dev
  /etc
  /home
  /media
  /mnt
  /opt
  /run
  /sbin
  /srv
  /usr
  /var
).each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode '0755'
  end
end

directory '/tmp' do
  owner 'root'
  group 'root'
  mode '1777'
end

# make sure /etc/mtab always points to the right info
link '/etc/mtab' do
  to '/proc/self/mounts'
end

# /run compatibility (both directions)
link '/var/run' do
  to '/run'
  not_if { File.symlink?('/run') }
end

link '/var/lock' do
  to '/run/lock'
  not_if { File.symlink?('/run/lock') }
end

link '/run' do
  to '/var/run'
  not_if { File.symlink?('/var/run') }
end

link '/run/lock' do
  to '/var/lock'
  not_if { File.symlink?('/var/lock') }
end

# global ag ignore file
file '/.agignore' do
  content([
    'dev/',
    'proc/',
    'run/',
    'sys/',
    'tmp/',
    'var/chef',
    'var/log/',
    'var/spool/',
  ].join("\n"))
  owner 'root'
  group 'root'
  mode '0644'
end
