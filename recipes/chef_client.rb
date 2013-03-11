#
# Cookbook Name:: log_pie
# Recipe:: chef-client
#
# Copyright 2013, KSONSoftware.com
# All rights reserved - Do Not Redistribute
# @author krogebry ( bryan.kroger@gmail.com )


begin
  ## Find the ElasticSearch nodes
  es_node = search( :node, "role:logstash_elasticsearch AND chef_environment:prod AND tags:chef_client" ).first

  template "/opt/logstash/server/etc/conf.d/chef_client.conf" do
  #template "/opt/logstash/server/etc/logstash.conf" do
    owner "logstash"
    group "logstash"
    source "chef_client_input.conf.erb"
    cookbook "log_pie"
    notifies :restart, "service[logstash_server]"
    variables({
      :port => 5670,
      :es_node => es_node["ipaddress"]
    })
  end
 
rescue => e
  Chef::Log.fatal( "Unable to frame up syslog config." )
  Chef::Log.debug(e.backtrace.join( "\n" ))

end
