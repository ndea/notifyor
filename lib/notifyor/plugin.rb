require 'active_support'
require 'redis'

module Notifyor
  module Plugin
    extend ::ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def notifyor(options = {})
        configure_plugin(options)
      end

      def configure_plugin(options = {})
        configuration = default_configuration.deep_merge(options)
        append_callbacks(configuration)
      end

      def append_callbacks(configuration)
        configuration[:only].each do |action|
          case action
            when :create
              self.after_commit -> { ::Notifyor.configuration.redis_connection.publish "notifyor", {message: configuration[:messages][:create].call(self)}.to_json }, on: :create, if: -> { configuration[:only].include? :create }
            when :update
              self.after_commit -> { ::Notifyor.configuration.redis_connection.publish "notifyor", {message: configuration[:messages][:update].call(self)}.to_json }, on: :update, if: -> { configuration[:only].include? :update }
            when :destroy
              self.before_destroy -> { ::Notifyor.configuration.redis_connection.publish "notifyor", {message: configuration[:messages][:destroy].call(self)}.to_json }, if: -> { configuration[:only].include? :destroy }
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