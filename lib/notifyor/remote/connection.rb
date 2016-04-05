require 'redis-objects'
require 'notifyor'
require 'notifyor/growl'
require 'notifyor/util/formatter'
require 'notifyor/errors/ssh_error'
module Notifyor
  module Remote
    class Connection

      def initialize
        @ssh_host = ::Notifyor.configuration.ssh_host
        @ssh_password = ::Notifyor.configuration.ssh_password
        @ssh_port = ::Notifyor.configuration.ssh_port
        @ssh_user = ::Notifyor.configuration.ssh_user
      end

      def build_ssh_cmd
        if @ssh_host.blank?
          raise ::Notifyor::Errors::SSHError, "no ssh host provided. Provide a host with the --ssh-host option or set it in your configuration."
        end
        ssh_cmd = @ssh_user.present? ? "ssh #{@ssh_user}:#{@ssh_password}@#{@ssh_host}" : "ssh #{@ssh_host}"
        ssh_cmd + " -p#{@ssh_port ? @ssh_port : 22}"
      end

      def build_redis_cmd(model_name)
        "redis-cli LPOP notifyor:#{model_name}"
      end

      def retrieve_value(model_name)
        %x(#{build_ssh_cmd} '#{build_redis_cmd(model_name)}')
      end

      def growl_message(model_name)
        value = retrieve_value(model_name)
        ::Notifyor::Growl.create_growl("Notifyor", value) unless Notifyor::Util::Formatter.squish!(value).empty?
      end
    end
  end
end