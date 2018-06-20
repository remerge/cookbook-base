include_recipe "sudo"

users_manage "sudo" do
  action [:create, :remove]
end
