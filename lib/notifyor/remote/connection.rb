require 'notifyor/growl'

module Notifyor
  module Remote
    class Connection
      attr_accessor :ssh_host

      def initialize(ssh_host)
        @ssh_host = ssh_host
      end

      def retrieve_value
        %x(ssh #{@ssh_host} 'redis-cli RPOP notifyor')
      end

      def growl_message
        ::Notifyor::Growl.create_growl("Benutzer erstellt", retrieve_value)
      end
    end
  end
end