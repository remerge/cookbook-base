# node.force_default['rsyslog']['preserve_fqdn'] = 'on'
# include_recipe 'rsyslog'

# we don't need syslog

systemd_service 'syslog.socket' do
  action [:stop, :disable]
end

systemd_service 'rsyslog' do
  action [:stop, :disable]
end

node.force_default['logrotate']['global']['compress'] = true

include_recipe 'logrotate'
