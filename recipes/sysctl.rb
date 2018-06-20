params = {
  "fs.inotify.max_user_watches" => 524288,
  "fs.nr_open" => 1048576,
  "fs.protected_hardlinks" => "1",
  "fs.protected_symlinks" => "1",
  "kernel.kptr_restrict" => "1",
  "kernel.panic" => 60,
  "kernel.printk" => "4 4 1 7",
  "kernel.sysrq" => "176",
  "net.core.netdev_max_backlog" => 10000,
  "net.core.rmem_default" => "33554432",
  "net.core.rmem_max" => "33554432",
  "net.core.somaxconn" => 1024,
  "net.core.wmem_default" => "33554432",
  "net.core.wmem_max" => 33554432,
  "net.ipv4.conf.all.accept_redirects" => 0,
  "net.ipv4.conf.all.accept_source_route" => 0,
  "net.ipv4.conf.all.promote_secondaries" => 1,
  "net.ipv4.conf.all.rp_filter" => 1,
  "net.ipv4.conf.all.send_redirects" => 0,
  "net.ipv4.conf.default.accept_redirects" => 0,
  "net.ipv4.conf.default.accept_source_route" => 0,
  "net.ipv4.conf.default.promote_secondaries" => 1,
  "net.ipv4.conf.default.rp_filter" => 1,
  "net.ipv4.conf.default.send_redirects" => 0,
  "net.ipv4.icmp_echo_ignore_broadcasts" => 1,
  "net.ipv4.ip_local_port_range" => "32768 65535",
  "net.ipv4.tcp_congestion_control" => "westwood",
  "net.ipv4.tcp_fin_timeout" => 5,
  "net.ipv4.tcp_rmem" => "10240 87380 33554432",
  "net.ipv4.tcp_sack" => 0,
  "net.ipv4.tcp_syncookies" => 1,
  "net.ipv4.tcp_timestamps" => 1,
  "net.ipv4.tcp_tw_reuse" => 0,
  "net.ipv4.tcp_wmem" => "10240 87380 33554432",
  "net.ipv6.conf.all.disable_ipv6" => 1,
  "net.ipv6.conf.default.disable_ipv6" => 1,
  "net.ipv6.conf.lo.disable_ipv6" => 1,
  "net.netfilter.nf_conntrack_max" => 1024 * 1024,
  "vm.max_map_count" => 262144,
  "vm.swappiness" => 0,
}

params.each do |k, v|
  sysctl_param k do
    value v
    only_if { File.exist?("/proc/sys/#{k.tr('.', '/')}") }
  end
end

file "/etc/sysctl.d/99-chef-attributes.conf" do
  action :delete
end
