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

        opts.on('--ssh-password password', 'Provide the ssh password for the deployment/remote server') do |password|
          ::Notifyor.configuration.ssh_password = password
        end

        opts.on('--ssh-port port', 'Provide the ssh port for the deployment/remote server') do |port|
          ::Notifyor.configuration.ssh_port = port
        end

        opts.on('--ssh-user user', 'Provide the ssh user for the deployment/remote server') do |user|
          ::Notifyor.configuration.ssh_user = user
        end
      end.parse!
    end

    def check_notifications
      loop do
        ::Notifyor.configuration.notifyor_models.each do |model|
          connection = Notifyor::Remote::Connection.new
          connection.growl_message(model.tableize)
        end
        sleep 5
      end
    end

  end
end