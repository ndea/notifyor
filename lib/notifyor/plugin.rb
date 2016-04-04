require 'notifyor'

module Notifyor
  module Plugin
    extend ActiveSupport::Concern

    included do
      include ::Redis::Objects
    end

    module ClassMethods
      attr_accessor :events

      def notify_me(options = {})
        self.events = ::Redis::List.new("notifyor:#{self.name.tableize}")
      end

    end

  end
end