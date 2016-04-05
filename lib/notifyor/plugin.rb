require 'active_support'

module Notifyor
  module Plugin
    extend ::ActiveSupport::Concern

    included do
      include ::Redis::Objects
      before_create :notify_create, if: -> { self.class.events.present? }
      before_destroy :notify_destroy, if: -> { self.class.events.present? }
    end

    def notify_create
      self.class.events << {record_id: self.id, record_type: self.class.to_s, notification_type: 'create'}
    end

    def notify_destroy
      self.class.events << {record_id: self.id, record_type: self.class.to_s, notification_type: 'destroy'}
    end

    module ClassMethods
      attr_accessor :events
      attr_accessor :notifyor_models

      def notifyor(options = {})
        ::Notifyor.configuration.notifyor_models.add(self.name)
        self.events = ::Redis::List.new("notifyor:#{self.name.tableize}", marshal: true)
      end
    end
  end
end