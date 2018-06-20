require 'ipaddress'

def reserved_v4?(ip)
  reserved = %w(10.0.0.0/8 172.16.0.0/12 192.168.0.0/16)

  begin
    ip = IPAddress::IPv4.new(ip) unless ip.is_a?(IPAddress::IPv4)
  rescue
    return false
  end

  reserved.any? do |i|
    IPAddress::IPv4.new(i).include?(ip)
  end
end

def v6?(ip)
  IPAddress::IPv6.new(ip)
  true
rescue
  false
end

def public_v6?(ip)
  begin
    ip = IPAddress::IPv6.new(ip) unless ip.is_a?(IPAddress::IPv6)
  rescue
    return false
  end

  IPAddress::IPv6.new('2000::/3').include?(ip)
end

all_ips = node['network']['interfaces'].values.map do |v|
  v['addresses'] ? v['addresses'].keys : []
end.flatten.sort.uniq

public_ipv4 = node['cloud_v2'] && node['cloud_v2']['public_ipv4']
public_ipv4 ||= node['cloud'] && node['cloud']['public_ipv4']
public_ipv4 ||= node['ipaddress']
public_ipv4 ||= '127.0.0.1'
public_ipv4 = IPAddress::IPv4.new(public_ipv4)

default['public_ipv4'] = public_ipv4.to_s unless reserved_v4?(public_ipv4)

first_local_ipv4 = all_ips.select do |ip|
  reserved_v4?(ip)
end.first

local_ipv4 = node['cloud_v2'] && node['cloud_v2']['local_ipv4']
local_ipv4 ||= node['cloud'] && node['cloud']['local_ipv4']
local_ipv4 ||= first_local_ipv4
local_ipv4 ||= '127.0.0.1'
local_ipv4 = IPAddress::IPv4.new(local_ipv4)

default['local_ipv4'] = local_ipv4.to_s if reserved_v4?(local_ipv4)

public_ipv6 = node['cloud_v2'] && node['cloud_v2']['public_ipv6']
public_ipv6 ||= node['cloud'] && node['cloud']['public_ipv6']
public_ipv6 ||= node['ip6address']
public_ipv6 ||= "::1"
public_ipv6 = IPAddress::IPv6.new(public_ipv6)

default['public_ipv6'] = public_ipv6.to_s if public_v6?(public_ipv6)

first_local_ipv6 = all_ips.select do |ip|
  v6?(ip) && !public_v6?(ip)
end.first

local_ipv6 = node['cloud_v2'] && node['cloud_v2']['local_ipv6']
local_ipv6 ||= node['cloud'] && node['cloud']['local_ipv6']
local_ipv6 ||= first_local_ipv6
local_ipv6 ||= "::1"
local_ipv6 = IPAddress::IPv6.new(local_ipv6)

default['local_ipv6'] = local_ipv6.to_s unless public_v6?(local_ipv6)
