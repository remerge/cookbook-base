include_recipe 'cron'

# support user specifying a space instead of underscore in zone file path
zone_file = node['system']['timezone'].sub(' ', '_')

# the zone file needs to exist in the system share to succeed
raise "#{zone_file} is not a valid timezone!" unless ::File.file?("/usr/share/zoneinfo/#{zone_file}")

# initially assume a zone change
zone_change = true

# when already a symlink to the zone_file, no need to reconfigure timezone
if ::File.symlink?('/etc/localtime')
  zone_change = !::File.readlink('/etc/localtime').include?(zone_file)
end

log "tz-info (before set): #{Time.now.strftime('%z %Z')}" do
  level :debug
  only_if { zone_change }
end

if %w(debian ubuntu).member? node['platform']
  package 'tzdata'

  bash 'dpkg-reconfigure tzdata' do
    user 'root'
    code '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata'
    action :nothing
  end

  file '/etc/timezone' do
    owner 'root'
    group 'root'
    content "#{zone_file}\n"
    notifies :run, 'bash[dpkg-reconfigure tzdata]'
  end
end

execute "timedatectl set-timezone #{zone_file}" do
  notifies :restart, 'service[cron]', :immediately
  notifies :create, 'ruby_block[verify newly-linked timezone]', :delayed
  only_if "bash -c 'type -P timedatectl'"
  not_if { Mixlib::ShellOut.new('timedatectl').run_command.stdout.include?(zone_file) }
end

link '/etc/localtime' do
  to "/usr/share/zoneinfo/#{zone_file}"
  notifies :restart, 'service[cron]', :immediately
  notifies :create, 'ruby_block[verify newly-linked timezone]', :delayed
  not_if "bash -c 'type -P timedatectl'"
end

ruby_block 'verify newly-linked timezone' do
  block do
    tz_info = ::Time.now.strftime('%z %Z')
    tz_info << "#{::File.readlink('/etc/localtime').gsub(/^/, ' (').gsub(/$/, ')')})"
    ::Chef::Log.debug("tz-info (after set): #{tz_info}")
  end
  action :nothing
  only_if { ::File.symlink?('/etc/localtime') }
  only_if { zone_change }
end
