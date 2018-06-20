service "ufw" do
  action [:disable, :stop]
end

package "ufw" do
  action :purge
end

directory "/etc/ufw" do
  action :delete
  recursive true
end

file "/etc/default/ufw-chef.rules" do
  action :delete
end

directory "/etc/firewall.d" do
  owner "root"
  group "root"
  mode "0755"
end

cookbook_file "/sbin/firewall" do
  source "firewall.sh"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, "service[firewall]"
end

template "/etc/firewall.d/00_internal.sh" do
  source "firewall_internal.sh"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, "service[firewall]"
  variables nodes: node_search("chef_environment:#{node.chef_environment}")
end

systemd_service "firewall" do
  after %w(network-online.target)
  wants %w(network-online.target)

  install do
    wanted_by 'multi-user.target'
  end

  service do
    type "oneshot"
    remain_after_exit true
    exec_start "/sbin/firewall"
    user "root"
    group "root"
  end

  notifies :restart, "service[firewall]"
end

service "firewall" do
  action [:enable]
end
