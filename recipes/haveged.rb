package 'haveged'

service 'haveged' do
  if lxc?
    action [:disable, :stop]
  else
    action [:enable, :start]
  end
end
