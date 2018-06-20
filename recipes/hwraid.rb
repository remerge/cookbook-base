apt_repository 'hwraid' do
  uri "http://hwraid.le-vert.net/#{node['platform']}"
  components ['main']
  distribution node['lsb']['codename']
  keyserver "hkp://keyserver.ubuntu.com"
  key "23B3D3B4"
  action :add
end

if node['block_device'].values.any? { |bd| bd['vendor'] == 'DELL' }
  package "megaclisas-status"
else
  package %w(megacli megactl) do
    action :purge
  end
end

package %w(cciss-vol-status hpacucli) do
  action :purge unless node['block_device'].values.any? { |bd|
    bd['vendor'] == 'HP'
  }
end
