require 'redis-objects'
require 'notifyor/growl'
require 'notifyor/util/formatter'
module Notifyor
  module Remote
    class Connection
      attr_accessor :ssh_host

      def initialize(ssh_host)
        @ssh_host = ssh_host
      end

      def retrieve_value(model_name)
        %x(ssh #{@ssh_host} 'redis-cli LPOP notifyor:#{model_name}')
      end

      def growl_message(model_name)
        value = retrieve_value(model_name)
        ::Notifyor::Growl.create_growl("Notifyor", value) unless Notifyor::Util::Formatter.squish!(value).empty?
      end
    end
  end
end