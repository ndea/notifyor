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
        configuration = default_configuration.deep_merge(options)
        append_callbacks(configuration)
      end

      def append_callbacks(configuration)
        configuration[:only].each do |action|
          case action
            when :create
              self.after_commit -> { self.class.notifyor_events << configuration[:messages][:create].call(self) }, on: :create, if: -> { configuration[:only].include? :create}
            when :update
              self.after_commit -> {self.class.notifyor_events << configuration[:messages][:update].call(self) }, on: :update, if: -> { configuration[:only].include? :update}
            when :destroy
              self.before_destroy -> {self.class.notifyor_events << configuration[:messages][:destroy].call(self)}, if: -> { configuration[:only].include? :destroy}
            else
              #nop
          end
        end
      end

      def default_configuration
        {
            only: [:create, :destroy, :update],
            messages: {
                create: -> (model) { I18n.t('notifyor.model.create', model: model.class.model_name.human) },
                update: -> (model) { I18n.t('notifyor.model.update', model: model.class.model_name.human) },
                destroy: -> (model) { I18n.t('notifyor.model.destroy', model: model.class.model_name.human) }
            }
        }
      end

    end
  end
end