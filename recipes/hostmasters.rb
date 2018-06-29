node.force_default['authorization']['sudo']['groups'] = ['sudo']
node.force_default['authorization']['sudo']['passwordless'] = true

include_recipe 'sudo'

users_manage 'sudo' do
  action [:create, :remove]
end
