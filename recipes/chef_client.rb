chef_ingredient 'chef' do
  action :upgrade
  version node['chef_client']['version']
end

node.override['chef_client']['log_file'] = nil
node.force_default['chef_client']['config']['log_location'] = :syslog

node.force_default['ohai']['disabled_plugins'] = [
  :Hostnamectl,
]

include_recipe 'chef-client::config'

directory node['chef_handler']['handler_path'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :nothing
end.run_action(:create)
