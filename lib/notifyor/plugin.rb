require 'active_support'

module Notifyor
  module Plugin
    extend ::ActiveSupport::Concern

    included do
    end

    module ClassMethods
      attr_accessor :events
      attr_accessor :notifyor_models

      def notifyor(options = {})
        self.extend ::Redis::Objects
        ::Notifyor.configuration.notifyor_models.add(self.name)
        self.events = ::Redis::List.new("notifyor:#{self.name.tableize}")
        append_callbacks
      end

      def append_callbacks
        self.send(:before_create, -> { self.class.events << I18n.t('notifyor.model.create', model: self.model_name.human) })
        self.send(:before_destroy, -> { self.class.events << I18n.t('notifyor.model.delete', model: self.model_name.human) })
      end

    end
  end
end