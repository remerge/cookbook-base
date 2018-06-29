# chef client first in case it upgrades itself
include_recipe 'base::chef_client'

# basic system configuration
include_recipe 'base::hostname'
include_recipe 'base::resolver'
include_recipe 'base::baselayout'
include_recipe 'base::sysctl'
include_recipe 'base::haveged'
include_recipe 'base::hwraid'

# systemd config and services
include_recipe 'systemd::journald'
include_recipe 'systemd::timezone'
include_recipe 'systemd::locale'
include_recipe 'systemd::machine'
include_recipe 'systemd::rtc'
include_recipe 'systemd::vconsole'

# platform specific resources
include_recipe "base::#{node['platform']}"

# authentication/authorization/security
include_recipe 'base::hostmasters'
include_recipe 'base::firewall'

# basic system tools
include_recipe 'build-essential'
include_recipe 'base::java'

# basic system services
include_recipe 'base::syslog'
include_recipe 'base::postfix'
include_recipe 'cron'
include_recipe 'ntp'
