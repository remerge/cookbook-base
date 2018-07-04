node.force_default['java']['install_flavor'] = 'oracle'
node.force_default['java']['jdk_version'] = '8'
node.force_default['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'java'

cruft = [
  'openjdk-8-jre-headless',
  'oracle-java8-installer',
  'default-jre-headless'
]

package cruft do
  action :purge
end
