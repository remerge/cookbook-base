default['chef_domain'] = node['domain']

if (match = node['fqdn'].sub(node['chef_domain'], '').match(/^(.+?)\.(.+?)\.$/))
  default['cluster']['name'] = match[2]
  default['cluster']['domain'] = "#{node.cluster_name}.#{node['chef_domain']}"
  default['parents'] = [node['cluster']['domain']]
else
  default['cluster']['name'] = node['chef_domain']
  default['cluster']['domain'] = nil
  default['parents'] = [node['chef_domain']]
end

if (match = node['hostname'].match(/(.+?)(\d+)$/))
  default['cluster']['host']['group'] = match[1]
  default['cluster']['host']['id'] = match[2].to_i
else
  default['cluster']['host']['group'] = node['hostname']
  default['cluster']['host']['id'] = 1
end
