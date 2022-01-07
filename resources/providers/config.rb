# Cookbook Name:: rsyslog
# Provider:: configure
#

include Rsyslog::Helper

action :add do
  begin
    enable_tls = new_resource.enable_tls
    config_dir = new_resource.config_dir
    certificates_dir = new_resource.certificates_dir
    rules_dir = new_resource.rules_dir
    remote_logs_dir = new_resource.remote_logs_dir
    work_dir = new_resource.work_dir
    user = new_resource.user
    group = new_resource.group
    kafka_server = new_resource.kafka_server
    cdomain = node["redborder"]["cdomain"]
    vault_nodes = new_resource.vault_nodes
    ips_nodes = new_resource.ips_nodes

    # Get vault and cep nodes

    ips = false

    if node.respond_to?"run_list" and (node.run_list.map{|x| x.name}.include?"ips-sensor" or node.run_list.map{|x| x.name}.include?"ipsv2-sensor" or node.run_list.map{|x| x.name}.include?"ipscp-sensor")
        ips = true
    end

    yum_package "rsyslog" do
      version "8.2001.0-1.el7"
      action :install
      flush_cache [:before]
    end
    yum_package "rsyslog-kafka" do
      version '8.2001.0-1.el7'
      action :install
      flush_cache [:before]
    end

    yum_package "rsyslog-mmnormalize" do
      version '8.2001.0-1.el7'
      action :install
      flush_cache [:before]
    end

    yum_package "rsyslog-mmjsonparse" do
      version '8.2001.0-1.el7'
      action :install
      flush_cache [:before]
    end


    #group group do
    #  action  :create
    #end

    #user user do
    #  comment 'rsyslog user'
    #  shell   '/sbin/nologin'
    #  group group
    #  action  :create
    #end

    directory config_dir do #"/etc/rsyslog.d"
      owner   'root'
      group   'root'
      mode    '0755'
      action  :create
    end

    if enable_tls
      directory certificates_dir do
        owner   'root'
        group   'root'
        mode    '0755'
        action  :create
      end
    end

    directory rules_dir do
      owner   'root'
      group   'root'
      mode    '0755'
      action  :create
    end

    directory work_dir do
      owner user
      group group
      mode  '0755'
      action  :create
    end

    directory remote_logs_dir do
      owner user
      group group
      mode  '0755'
      action  :create
    end

    directory '/var/spppl' do #CHECK IF NEEDED
      owner 'root'
      group 'root'
      mode 0700
    end

    directory '/var/spppl/rsyslog' do #CHECK IF NEEDED
      owner 'root'
      group 'root'
      mode 0700
    end

    if node[:redborder][:rsyslog][:is_server] #CHECK IF NEEDED
      template '/etc/logrotate.d/log-sensors' do
        source 'rsyslog_log-sensors.erb'
        cookbook "rsyslog"
        owner 'root'
        group 'root'
        mode 0644
        retries 2
      end
    end

    template '/etc/rsyslog.conf' do
      source  'rsyslog.conf.erb'
      cookbook "rsyslog"
      owner 'root'
      group   'root'
      mode  '0644'
      retries 2
      notifies :restart, 'service[rsyslog]', :delayed
    end

    template '/etc/sysconfig/rsyslog' do
      source 'rsyslog_sysconfig.erb'
      cookbook "rsyslog"
      owner 'root'
      group 'root'
      mode 0644
      retries 2
      notifies :restart, "service[rsyslog]"
    end

    template "#{config_dir}/01-server.conf" do
      source  'rsyslog_01-server.conf.erb'
      cookbook "rsyslog"
      owner 'root'
      group   'root'
      mode  '0644'
      retries 2
      notifies :restart, 'service[rsyslog]', :delayed
    end

    template "#{config_dir}/02-general.conf" do
      source  'rsyslog_02-general.conf.erb'
      cookbook "rsyslog"
      owner 'root'
      group   'root'
      mode  '0644'
      retries 2
      notifies :restart, 'service[rsyslog]', :delayed
    end

    template "#{config_dir}/99-parse_rfc5424.conf" do
      source  'rsyslog_99-parse_rfc5424.conf.erb'
      cookbook "rsyslog"
      owner 'root'
      group   'root'
      mode  '0644'
      retries 2
      notifies :restart, 'service[rsyslog]', :delayed
      variables(:cdomain => cdomain, :kafka_server => kafka_server, :vault_nodes => vault_nodes, :ips => ips)
    end

    template "#{config_dir}/20-redborder.conf" do
      source  'rsyslog_20-redborder.conf.erb'
      cookbook "rsyslog"
      owner 'root'
      group   'root'
      mode  '0644'
      retries 2
      notifies :restart, 'service[rsyslog]', :delayed
      variables(:ips_nodes => ips_nodes, :ips => ips)
    end

    service "rsyslog" do
      # provider Chef::Provider::Service::Init::Redhat
      service_name "rsyslog"
      supports :status => true, :start => true, :restart => true, :enable => true
      ignore_failure true
      action [:enable, :start]
    end

    Chef::Log.info("rsyslog has been configured correctly.")

  rescue Exception => e
    Chef::Log.error(e.message)
  end
end

action :remove do #Usually used to uninstall something
  begin
    config_dir = new_resource.config_dir

    service "rsyslog" do
      supports :stop => true, :disable => true
      action [:stop, :disable]
    end
    # Delete rsyslog config file
    # template "#{config_dir}/rsyslog" do
    #   action :delete
    #   backup false
    # end

    # Uninstall rsyslog service.
    # package 'Uninstall iptables' do
    #   case node[:platform]
    #   when 'centos'
    #     package_name 'rsyslog'
    #   end
    #   action :remove
    # end

    Chef::Log.info("Rsyslog cookbook has been processed")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :register do #Usually used to register in consul
  begin
    if !node["rsyslog"]["registered"]
      query = {}
      query["ID"] = "rsyslog-#{node["hostname"]}"
      query["Name"] = "rsyslog"
      query["Address"] = "#{node["ipaddress"]}"
      query["Port"] = 514
      json_query = Chef::JSONCompat.to_json(query)

      execute 'Register service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/register -d '#{json_query}' &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.set["rsyslog"]["registered"] = true
    end
    Chef::Log.info("rsyslog service has been registered in consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :deregister do #Usually used to deregister from consul
  begin
    if node["rsyslog"]["registered"]
      execute 'Deregister service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/deregister/rsyslog-#{node["hostname"]} &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.set["rsyslog"]["registered"] = false
    end
    Chef::Log.info("rsyslog service has been deregistered from consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end
