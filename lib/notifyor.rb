require 'redis'
require 'redis-objects'
require 'connection_pool'
require 'notifyor/plugin'

module Notifyor
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :redis_connection
    attr_accessor :notifyor_models

    def initialize
      @redis_connection = ::Redis.new
      Redis::Objects.redis = ::ConnectionPool.new(size: 5, timeout: 5) { @redis_connection }
      @notifyor_models = ActiveRecord::Base.connection.tables.map do |model|
        model.capitalize.singularize.camelize
      end.select do |model|
        model != 'SchemaMigration' &&
            model.constantize.events
      end
    end
  end
end

ActiveRecord::Base.send :include, ::Notifyor::Plugin