module Notifyor
  module Remote
    class Connection
      attr_accessor :ssh_host

      def initialize(ssh_host)
        @ssh_host = ssh_host
      end

      def retrieve_value(model_name)
        ::Redis::List.new("notifyor:#{model_name.tableize}")
        %x(ssh #{@ssh_host} 'redis-cli RPOP notifyor')
      end

      def growl_message
        value = retrieve_value('users')
        ::Notifyor::Growl.create_growl("Benutzer erstellt", value) unless value.squish.blank?
      end

      def check_notifications
        %x(ssh #{@ssh_host} 'bash -l' < /Volumes/Data/development/open_source/notifyor/bin/remote.sh)
      end

    end
  end
end