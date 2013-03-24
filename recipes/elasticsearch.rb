##
# Cookbook Name:: log_pie
# Recipe:: elasticsearch
#
# Installs elastic search
#
# Copyright 2013, KSONSoftware.com
# All rights reserved - Do Not Redistribute
# @author krogebry ( bryan.kroger@gmail.com )

include_recipe "java"

execute "dl es" do
  command "wget -O /mnt/elasticsearch-0.20.5.deb https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.5.deb"
  not_if(File.exist?( "/mnt/elasticsearch-0.20.5.deb" ).to_s)
end

execute "install es" do
  command "dpkg -i /mnt/elasticsearch-0.20.5.deb"
  not_if("dpkg --list|grep elasticsearch")
end

execute "install head plugin" do
  command "/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head"
  not_if(File.exists?( "/usr/share/elasticsearch/plugins/head/" ).to_s)
end

cookbook_file "/etc/init.d/elasticsearch" do
  mode "0755"
  owner "elasticsearch"
  group "elasticsearch"
  source "es_init.erb"
end

directory "/etc/elasticsearch/" do
  owner "elasticsearch"
  group "elasticsearch"
  action :create
  recursive true
end

directory "/var/run/elasticsearch/" do
  owner "elasticsearch"
  group "elasticsearch"
  action :create
  recursive true
end

directory "/mnt/elasticsearch/" do
  owner "elasticsearch"
  group "elasticsearch"
  action :create
  recursive true
end

directory "/mnt/elasticsearch/data" do
  owner "elasticsearch"
  group "elasticsearch"
  action :create
  recursive true
end

directory "/mnt/elasticsearch/logs" do
  owner "elasticsearch"
  group "elasticsearch"
  action :create
  recursive true
end

#template "/etc/elasticsearch/elasticsearch.yml" do
  #source "elasticsearch.yml.erb"
  #notifies :restart, "service[elasticsearch]"
  #variables({
    #:log_dir => "/mnt/elasticsearch/logs",
    #:data_dir => "/mnt/elasticsearch/data",
    #:cluster_name => node['elasticsearch']['cluster_name']
  #})
#end

#template "/etc/default/elasticsearch" do
  #source "elasticsearch.defaults.erb"
  #notifies :restart, "service[elasticsearch]"
  #variables({
    #:log_dir => "/mnt/elasticsearch/logs",
    #:data_dir => "/mnt/elasticsearch/data"
  #})
#end

service "elasticsearch" do
  supports :restart => true, :reload => true, :status => true
  action [ :enable ]
end

