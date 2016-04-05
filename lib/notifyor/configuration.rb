require 'redis-objects'
require 'connection_pool'
module Notifyor
  class Configuration
    attr_accessor :redis_connection
    attr_accessor :notifyor_models
    attr_accessor :ssh_host

    def initialize
      @redis_connection = ::Redis.new
      Redis::Objects.redis = ::ConnectionPool.new(size: 5, timeout: 5) { @redis_connection }
      @notifyor_models = Set.new
      @ssh_host = 'localhost'
    end
  end
end