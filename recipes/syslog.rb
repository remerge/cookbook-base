node.force_default['rsyslog']['preserve_fqdn'] = 'on'

include_recipe 'rsyslog'

node.force_default['logrotate']['global']['compress'] = true

include_recipe 'logrotate'
