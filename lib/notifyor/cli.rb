require 'notifyor'
require 'active_support/dependencies'

module Notifyor
  class CLI
    def boot_system
      require './config/application'
      ActiveSupport::Dependencies.require_dependency 'notifyor'
      ::Rails.application.require_environment!
      ::Rails.application.eager_load!
    end

    def parse
      OptionParser.new do |opts|
        opts.banner = 'Usage: notify_me [options]'

        opts.on('-v', '--version',
                'Show the current version of this gem') do
          puts "Notifyor Version: #{::Notifyor::VERSION}"; exit
        end

        opts.on('--ssh-host host', 'Provide the host address to your deployment/remote server') do |host|
          ::Notifyor.configuration.ssh_host = host
        end

        opts.on('--ssh-port port', 'Provide the ssh port for the deployment/remote server') do |port|
          ::Notifyor.configuration.ssh_port = port
        end

        opts.on('--ssh-user user', 'Provide the ssh user for the deployment/remote server') do |user|
          ::Notifyor.configuration.ssh_user = user
        end

        opts.on('--tunnel-port tunnel_port', 'Provide the ssh user for the deployment/remote server') do |tunnel_port|
          ::Notifyor.configuration.tunnel_port = tunnel_port
        end

        opts.on('--redis-port redis_port', 'Provide the ssh user for the deployment/remote server') do |redis_port|
          ::Notifyor.configuration.redis_port = redis_port
        end
      end.parse!
    end

    def check_notifications
      connection = Notifyor::Remote::Connection.new
      begin
        connection.build_tunnel
        connection.build_redis_tunnel_connection
        connection.subscribe_to_redis
      rescue => e
        STDOUT.write "Could not establish SSH tunnel. Reason: #{e.message}"
      end
    end

  end
end