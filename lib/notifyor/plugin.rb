require 'active_support'

module Notifyor
  module Plugin
    extend ::ActiveSupport::Concern

    included do
      after_commit :notifyor_create_callback, on: :create, if: :on_create?
      after_commit :notifyor_update_callback, on: :update, if: :on_update?
      after_destroy :notifyor_destroy_callback, if: :on_destroy?
    end

    def on_create?
      self.class.plugin_configuration[:only].include? :create
    end

    def on_update?
      self.class.plugin_configuration[:only].include? :update
    end

    def on_destroy?
      self.class.plugin_configuration[:only].include? :destroy
    end

    def notifyor_create_callback
      self.class.notifyor_events << self.class.plugin_configuration[:messages][:create].call(self)
    end

    def notifyor_update_callback
      self.class.notifyor_events << self.class.plugin_configuration[:messages][:update].call(self)
    end

    def notifyor_destroy_callback
      self.class.notifyor_events << self.class.plugin_configuration[:messages][:destroy].call(self)
    end

    module ClassMethods
      attr_accessor :notifyor_events
      attr_accessor :notifyor_models
      attr_accessor :plugin_configuration

      def notifyor(options = {})
        configure_plugin(options)
        self.extend ::Redis::Objects
        ::Notifyor.configuration.notifyor_models.add(self.name)
        self.notifyor_events = ::Redis::List.new("notifyor:#{self.name.tableize}")
      end

      def configure_plugin(options = {})
        self.plugin_configuration = default_configuration.deep_merge(options)
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