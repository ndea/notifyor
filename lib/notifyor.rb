$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'notifyor/plugin'
require 'notifyor/configuration'

module Notifyor
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  ActiveRecord::Base.send(:include, ::Notifyor::Plugin) if defined?(ActiveRecord)
end