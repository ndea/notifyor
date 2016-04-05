require 'active_support'

module Notifyor
  module Plugin
    extend ::ActiveSupport::Concern

    included do
    end

    module ClassMethods
      attr_accessor :notifyor_events
      attr_accessor :notifyor_models

      def notifyor(options = {})
        configure_plugin(options)
        self.extend ::Redis::Objects
        ::Notifyor.configuration.notifyor_models.add(self.name)
        self.notifyor_events = ::Redis::List.new("notifyor:#{self.name.tableize}")
      end

      def configure_plugin(options = {})
        configuration = default_configuration.update(options)
        append_callbacks(configuration)
      end

      def default_configuration
        {
            only: [:create, :destroy, :update],
            messages: {
                create: I18n.t('notifyor.model.create', model: self.model_name.human),
                update: I18n.t('notifyor.model.update', model: self.model_name.human),
                destroy: I18n.t('notifyor.model.destroy', model: self.model_name.human)
            }
        }
      end

      def append_callbacks(configuration)
        configuration[:only].each do |action|
          case action
            when :create
              self.after_commit -> { self.class.notifyor_events << configuration[:messages][:create] }, on: :create
            when :update
              self.after_commit -> { self.class.notifyor_events << configuration[:messages][:update] }, on: :update
            when :destroy
              self.before_destroy -> { self.class.notifyor_events << configuration[:messages][:destroy] }
            else
              #nop
          end
        end
      end

    end
  end
end