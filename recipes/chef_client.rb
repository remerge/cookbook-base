chef_ingredient 'chef' do
  action :upgrade
  version node['chef_client']['version']
end

include_recipe 'chef-client::config'

directory node[:chef_handler][:handler_path] do
  owner 'root'
  group 'root'
  mode '0755'
  action :nothing
end.run_action(:create)
