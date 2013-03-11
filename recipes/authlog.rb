#
# Cookbook Name:: log_pie
# Recipe:: authlog
#
# Copyright 2013, KSONSoftware.com
# All rights reserved - Do Not Redistribute
# @author krogebry ( bryan.kroger@gmail.com )


begin
  ## Find the ElasticSearch nodes
  es_node = search( :node, "role:logstash_elasticsearch AND chef_environment:prod AND tags:authlog" ).first

  #template "/opt/logstash/server/etc/logstash.conf" do
  template "/opt/logstash/server/etc/conf.d/authlog.conf" do
    owner "logstash"
    group "logstash"
    source "authlog_input.conf.erb"
    cookbook "log_pie"
    notifies :restart, "service[logstash_server]"
    variables({
      :port => 5611,
      :es_node => es_node["ipaddress"]
    })
  end
 
rescue => e
  Chef::Log.fatal( "log_pie::authlog: Unable to frame up authlog config: %s" % e  )
  Chef::Log.info( "log_pie::authlog: %s" % e.backtrace.join( "\n" ))

end
