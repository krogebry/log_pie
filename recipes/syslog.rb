#
# Cookbook Name:: log_pie
# Recipe:: syslog
#
# Copyright 2013, KSONSoftware.com
# All rights reserved - Do Not Redistribute
# @author krogebry ( bryan.kroger@gmail.com )


begin
  ## Find the ElasticSearch nodes
  es_node = search( :node, "role:logstash_elasticsearch AND chef_environment:prod AND tags:syslog" ).first

  template "/opt/logstash/server/etc/conf.d/syslog.conf" do
  #template "/opt/logstash/server/etc/logstash.conf" do
    owner "logstash"
    group "logstash"
    source "syslog_input.conf.erb"
    cookbook "log_pie"
    notifies :restart, "service[logstash_server]"
    variables({
      :port => 5610,
      :es_node => es_node["ipaddress"]
    })
  end
 
rescue => e
  Chef::Log.fatal( "Unable to frame up syslog config." )
  Chef::Log.debug(e.backtrace.join( "\n" ))

end
