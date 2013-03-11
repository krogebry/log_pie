##
# Cookbook Name:: log_pie
# Recipe:: elasticsearch
#
# Installs elastic search
#
# Copyright 2013, KSONSoftware.com
# All rights reserved - Do Not Redistribute
# @author krogebry ( bryan.kroger@gmail.com )

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

link "/var/lib/elasticsearch" do
  not_if File.exists?( "/var/lib/elasticsearch" ).to_s
  to "/mnt/elasticsearch/data"
end

directory "/mnt/elasticsearch/logs" do
  owner "elasticsearch"
  group "elasticsearch"
  action :create
  recursive true
end

link "/var/log/elasticsearch" do
  not_if File.exists?( "/var/log/elasticsearch" ).to_s
  to "/mnt/elasticsearch/logs"
end

