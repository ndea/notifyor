require 'redis'
require 'connection_pool'
module Notifyor
  class Configuration
    attr_accessor :redis_connection
    attr_accessor :ssh_host
    attr_accessor :ssh_user
    attr_accessor :ssh_port
    attr_accessor :tunnel_port
    attr_accessor :redis_port

    def initialize
      @redis_connection = ::Redis.new
      @ssh_port = '22'
      @ssh_host = 'localhost'
      @tunnel_port ='2000'
      @redis_port = '6379'
    end
  end
end