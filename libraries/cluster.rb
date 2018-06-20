# recipe helpers for cluster search
module ClusterHelper
  module Node
    def cluster_name
      if self['cluster'] && self['cluster']['name']
        self['cluster']['name']
      else
        self['fqdn']
      end
    end

    def cluster_domain
      self['cluster']['domain'] if self['cluster'] && self['cluster']['domain']
    end

    def clustered?
      cluster_name != self['fqdn']
    end

    def cluster?(name)
      name ? cluster_name == name : true
    end
  end

  module Search
    def node_search(query, filter = {}) # rubocop:disable Metrics/MethodLength
      search(:node, query, filter_result: filter.merge(
        'fqdn' => %w(fqdn),
        'hostname' => %w(hostname),
        'domain' => %w(domain),
        'public_ipv4' => %w(public_ipv4),
        'local_ipv4' => %w(local_ipv4),
        'public_ipv6' => %w(public_ipv6),
        'local_ipv6' => %w(local_ipv6),
        'cluster_name' => %w(cluster name),
        'cluster_host_group' => %w(cluster host group),
        'cluster_host_id' => %w(cluster host id),
      )).sort do |a, b|
        a['fqdn'].to_s <=> b['fqdn'].to_s
      end
    end

    def cluster_search(query, cluster_name = nil, filter = {})
      cluster_name ||= node.cluster_name
      node_search("cluster_name:#{cluster_name} AND (#{query})", filter)
    end
  end
end

include ClusterHelper
Chef::Node.send(:include, ClusterHelper::Node)
Chef::Recipe.send(:include, ClusterHelper::Search)
Chef::Resource.send(:include, ClusterHelper::Search)
