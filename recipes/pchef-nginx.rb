#
# Cookbook Name:: log_pie
# Recipe:: pchef-nginx
#
# Copyright 2013, KSONSoftware.com
# All rights reserved - Do Not Redistribute
# @author krogebry ( bryan.kroger@gmail.com )


begin
  ## Find the ElasticSearch nodes
  es_nodes = search( :node, "role:logstash_elasticsearch_master AND chef_environment:prod AND tags:%s" % node['tags'].first ).sort

  if(es_nodes.count > 1)
    #sorted = es_nodes.map{|n| n["ipaddress"] }.sort
    #es_node = sorted[rand(sorted.size)]
    es_node = es_nodes.first["ipaddress"]
  else
    es_node = es_nodes.first["ipaddress"]
  end

  template "/opt/logstash/server/etc/conf.d/pchef_nginx.conf" do
    owner "logstash"
    group "logstash"
    source "pchef_nginx.conf.erb"
    cookbook "log_pie"
    notifies :restart, "service[logstash_server]"
    variables({
      :port => 5671,
      :es_node => es_node,
      :es_cluster => "fat-log"
    })
  end
 
rescue => e
  Chef::Log.fatal( "Unable to frame up the logstash config: %s" % e )
  Chef::Log.info(e.backtrace.join( "\n" ))

end
