module Rsyslog
  module Helper
    def get_vault_nodes
      # return a list of the vault nodes
      vault_nodes = []

      managers_keys = Chef::Node.list.keys.sort
      managers_keys.each do |m_key|
        m = nil
        begin
          m = Chef::Node.load m_key
        rescue
          Chef::Log.error("[get_vault_nodes] Failed to load node: #{m_key}")
        end

        # TODO: Refactor this
        begin
          roles = m['roles']
        rescue NoMethodError
          begin
            roles = m.run_list
          rescue
            roles = []
          end
        end

        next unless roles && !roles.empty? && !roles.include?('manager')

        if m.respond_to?('run_list') && (m.run_list.map(&:name).include?('vault-sensor') || m.run_list.map(&:name).include?('cep-sensor'))
          vault_nodes << m
        end
      end
      vault_nodes
    end

    def get_ips_nodes
      # return a list of the vault nodes
      ips_nodes = []

      managers_keys = Chef::Node.list.keys.sort
      managers_keys.each do |m_key|
        m = nil
        begin
          m = Chef::Node.load m_key
        rescue
          Chef::Log.error("[get_ips_nodes] Failed to load node: #{m_key}")
        end

        # TODO: Refactor this
        begin
          roles = m['roles']
        rescue NoMethodError
          begin
            roles = m.run_list
          rescue
            roles = []
          end
        end

        next unless roles && !roles.empty? && !roles.include?('manager')

        if m.respond_to?('run_list') && (m.run_list.map(&:name).include?('ips-sensor') || m.run_list.map(&:name).include?('ipsv2-sensor') || m.run_list.map(&:name).include?('ipscp-sensor'))
          ips_nodes << m
        end
      end
      ips_nodes
    end
  end
end
