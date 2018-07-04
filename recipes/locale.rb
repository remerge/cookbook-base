systemd_service_drop_in 'systemd-localed' do
  override 'systemd-localed.service'
  service do
    private_devices false
    private_network false
  end
  only_if { lxc? }
end

include_recipe 'systemd::locale'
