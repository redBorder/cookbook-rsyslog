default["redborder"]["rsyslog"]["enable_tcp"] = true
default["redborder"]["rsyslog"]["enable_tls"] = false
default["redborder"]["rsyslog"]["enable_udp"] = true
default["redborder"]["rsyslog"]["enable_client_proxy_logs"] = true
default["redborder"]["rsyslog"]["udp_port"] = 514
default["redborder"]["rsyslog"]["tcp_port"] = 514

default["redborder"]["rsyslog"]["enable_hash"] = false
default["redborder"]["rsyslog"]["hash_key"] = "yourenterprisekey"
default["redborder"]["rsyslog"]["hash_function"] = "sha256"

default["redborder"]["rsyslog"]["config_dir"] = "/etc/rsyslog.d"
default["redborder"]["rsyslog"]["certificates_dir"] = "#{node["redborder"]["rsyslog"]["config_dir"]}/certificates"
default["redborder"]["rsyslog"]["rules_dir"] = "#{node["redborder"]["rsyslog"]["config_dir"]}/rules"
default["redborder"]["rsyslog"]["remote_logs_dir"] = "/var/log/remote"
default["redborder"]["rsyslog"]["work_dir"] = "/var/spool/rsyslog"

default["redborder"]["rsyslog"]["permitted_peers_array"] = ['*.example.com','*.redborder.com']

default["redborder"]["rsyslog"]["user"] = "root"
default["redborder"]["rsyslog"]["group"] = "root"

# From old attributes file
#default["redborder"]["rsyslog"]["service"] = "rsyslog"
default["redborder"]["rsyslog"]["is_server"] = false
default["redborder"]["rsyslog"]["loggly"] = {}
default["redborder"]["rsyslog"]["loggly"]["token"] = ""
default["redborder"]["rsyslog"]["service"] = "rsyslog"
default["redborder"]["rsyslog"]["tcpservers"] = []
default["redborder"]["rsyslog"]["udpservers"] = []
default["redborder"]["rsyslog"]["servers"] = []
default["redborder"]["rsyslog"]["protocol"] = "udp"
default["redborder"]["rsyslog"]["syslog_mode"] = "extended"
default["redborder"]["rsyslog"]["savelocally"] = true
