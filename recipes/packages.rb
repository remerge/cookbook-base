unless (node['packages'][node['platform_family']] || []).empty?
  package node['packages'][node['platform_family']]
end
