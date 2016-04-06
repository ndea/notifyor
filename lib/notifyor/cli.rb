require 'notifyor/version'
require 'active_support/dependencies'

module Notifyor
  class CLI

    def parse
      # Default configuration.
      ENV['ssh_host'] = 'localhost'
      ENV['ssh_port'] = '22'
      ENV['ssh_tunnel_port'] = '2000'
      ENV['ssh_redis_port'] = '6379'

      OptionParser.new do |opts|
        opts.banner = 'Usage: notify_me [options]'

        opts.on('-v', '--version',
                'Show the current version of this gem') do
          puts "Notifyor Version: #{::Notifyor::VERSION}"; exit
        end

        opts.on('--ssh-host host', 'Provide the host address to your deployment/remote server') do |host|
         ENV['ssh_host'] = host
        end

        opts.on('--ssh-port port', 'Provide the ssh port for the deployment/remote server') do |port|
          ENV['ssh_port'] = port
        end

        opts.on('--ssh-user user', 'Provide the ssh user for the deployment/remote server') do |user|
          ENV['ssh_user'] = user
        end

        opts.on('--tunnel-port tunnel_port', 'Provide the ssh user for the deployment/remote server') do |tunnel_port|
          ENV['ssh_tunnel_port'] = tunnel_port
        end

        opts.on('--redis-port redis_port', 'Provide the ssh user for the deployment/remote server') do |redis_port|
          ENV['ssh_redis_port'] = redis_port
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