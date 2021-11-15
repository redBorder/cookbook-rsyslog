#
# Cookbook Name:: rsyslog
# Recipe:: default
#
# Copyright 2016, redborder
#
# All rights reserved - Do Not Redistribute
rsyslog_config "add" do
  enable_tls node["redborder"]["rsyslog"]["enable_tls"]
  config_dir node["redborder"]["rsyslog"]["config_dir"]
  certificates_dir node["redborder"]["rsyslog"]["certificates_dir"]
  rules_dir node["redborder"]["rsyslog"]["rules_dir"]
  remote_logs_dir node["redborder"]["rsyslog"]["remote_logs_dir"]
  work_dir node["redborder"]["rsyslog"]["work_dir"]
  user node["redborder"]["rsyslog"]["user"]
  group node["redborder"]["rsyslog"]["group"]
  action :add
end
