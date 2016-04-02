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

    def initialize
      @redis_connection = Redis.new
    end
  end
end
