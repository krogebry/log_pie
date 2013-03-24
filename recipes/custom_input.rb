##
# Cookbook Name:: log_pie
# Recipe:: custom-input
#
# Copyright 2013, KSONSoftware.com
# All rights reserved - Do Not Redistribute
# @author krogebry ( bryan.kroger@gmail.com )

if(node.has_key?( "logstash" ) && node["logstash"].has_key?( "inputs" ))
  node["logstash"]["inputs"].each do |input_name,input_cfg|
    begin
      res = search( :node, input_cfg["query"].map{|k,v| "%s:%s" % [k,v] }.join( " AND " ))

      filters = {}
      cluster_name = nil

      if(input_cfg.has_key?( "cluster" ) && input_cfg["cluster"] != false)
        es_node = res.first
        cluster_name = input_cfg["cluster"]

      else
        es_node = res.first

      end

      filters = input_cfg["filters"] if(input_cfg.has_key?( "filters" ))

      template "/opt/logstash/server/etc/conf.d/%s.conf" % input_name do
        owner "logstash"
        group "logstash"
        source "custom-input.conf.erb"
        cookbook "log_pie"
        notifies :restart, "service[logstash_server]"
        variables({
          :name => input_name,
          :port => input_cfg["port"],
          :es_node => es_node["ipaddress"],
          :filters => filters,
          :cluster_name => cluster_name
        })
      end
 
    rescue => e
      Chef::Log.fatal( "Unable to frame input config for: %s" % input_name )
      Chef::Log.info(e.backtrace.join( "\n" ))

    end

  end
end
