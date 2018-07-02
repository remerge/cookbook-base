node.override['postfix']['main']['forward_path'] = '/etc/postfix/adminaddr'
node.override['postfix']['main']['mydestination'] = []

include_recipe 'postfix'
include_recipe 'postfix::sasl_auth'

file '/etc/postfix/adminaddr' do
  content "#{node['postfix']['adminaddr']}\n"
  owner 'root'
  group 'root'
  mode '0644'
end
