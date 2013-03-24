##
# Cookbook Name:: log_pie
# Recipe:: elasticsearch
#
# Installs elastic search
#
# Copyright 2013, KSONSoftware.com
# All rights reserved - Do Not Redistribute
# @author krogebry ( bryan.kroger@gmail.com )

begin
  es_masters = search( :node, "chef_environment:prod AND role:logstash_elasticsearch_master AND tags:%s" % node["tags"].first ).sort

  template "/etc/elasticsearch/elasticsearch.yml" do
    source "elasticsearch-data.yml.erb"
    notifies :restart, "service[elasticsearch]"
    variables({
      :log_dir => "/mnt/elasticsearch/logs",
      :data_dir => "/mnt/elasticsearch/data",
      :es_masters => es_masters,
      :cluster_name => node['elasticsearch']['cluster_name'],
    })
  end

rescue => e
  Chef::Log.fatal( "Caught exception while creating the elasticcache data bits: %s" % e )
  Chef::Log.info( e.backtrace )

end

