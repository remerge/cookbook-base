# node.force_default['rsyslog']['preserve_fqdn'] = 'on'
# include_recipe 'rsyslog'

service "rsyslog" do
  action [:stop, :disable]
end

node.force_default['logrotate']['global']['compress'] = true

include_recipe 'logrotate'
