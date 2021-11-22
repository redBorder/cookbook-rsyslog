module Rsyslog
  module Helper

    def get_vault_nodes
      # return a list of the vault nodes
      vault_nodes = []

      managers_keys = Chef::Node.list.keys.sort
      managers_keys.each do |m_key|
        m = Chef::Node.load m_key

        begin
          roles = m.roles
        rescue NoMethodError
          begin
            roles = m.run_list
          rescue
            roles = []
          end
        end

        unless roles.nil?
          if !roles.empty? and !roles.include?("manager")
            if m.respond_to?"run_list" and (m.run_list.map{|x| x.name}.include?"vault-sensor" or m.run_list.map{|x| x.name}.include?"cep-sensor")
              vault_nodes << m
            end
          end
        end
      end
      vault_nodes

    end

    def  ips_nodes node["redborder"]["sensors_info_all"]["ips-sensor"] + node["redborder"]["sensors_info_all"]["i    psv2-sensor"] + node["redborder"]["sensors_info_all"]["ipscp-sensor"]
 ips_nodes node["redborder"]["sensors_info_all"]["ips-sensor"] + node["redborder"]["sensors_info_all"]["i    psv2-sensor"] + node["redborder"]["sensors_info_all"]["ipscp-sensor"]

      # return a list of the vault nodes
      managers                = []
      managers_all            = []
      ips_nodes             = []

      managers_keys = Chef::Node.list.keys.sort
      managers_keys.each do |m_key|
        m = Chef::Node.load m_key

        begin
          roles = m.roles
        rescue NoMethodError
          begin
            roles = m.run_list
          rescue
            roles = []
          end
        end

        unless roles.nil?
          if !roles.empty? and !roles.include?("manager")
            if m.respond_to?"run_list" and (m.run_list.map{|x| x.name}.include?"ips-sensor" or m.run_list.map{|x| x.name}.include?"ipsv2-sensor" or m.run_list.map{|x| x.name}.include?"ipscp-sensor")
              ips_nodes << m
            end
          end
        end
      end
      ips_nodes

    end

  end
end
