include_recipe "postfix"
include_recipe "postfix::sasl_auth"

file "/etc/postfix/adminaddr" do
  content "#{node['postfix']['adminaddr']}\n"
  owner "root"
  group "root"
  mode "0644"
end
