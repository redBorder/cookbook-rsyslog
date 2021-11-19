# Cookbook Name:: rsyslog
# Resource:: configure
#

actions :add, :register, :deregister, :remove
default_action :add

attribute :enable_tls, :kind_of => [TrueClass, FalseClass], :default => true
attribute :config_dir, :kind_of => String, :default => "/etc/rsyslog.d"
attribute :certificates_dir, :kind_of => String, :default => "/etc/rsyslog.d/certificates"
attribute :rules_dir, :kind_of => String, :default => "/etc/rsyslog.d/rules"
attribute :remote_logs_dir, :kind_of => String, :default => "/var/log/remote"
attribute :work_dir, :kind_of => String, :default => "/var/spool/rsyslog"
attribute :user, :kind_of => String, :default => "syslog"
attribute :group, :kind_of => String, :default => "syslog"
attribute :kafka_server, :kind_of => String, :default => "kafka.service"
attribute :vault_nodes, :kind_of => Array, :default => []
attribute :ips_nodes, :kind_of => Array, :default => []