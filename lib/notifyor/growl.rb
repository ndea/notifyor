require 'notifyor/util/os_analyzer'
module Notifyor
  module Growl
    extend self

    def adapter
      return @adapter if @adapter
      self.adapter =
          case ::Notifyor::Util::OSAnalyzer.os
            when :macosx
              :terminal_notifier
            when :linux
              :libnotify_notifier
            when :unix
              :libnotify_notifier
            else
              raise 'Operating system not recognized.'
          end
      @adapter
    end

    def adapter=(adapter_name)
      case adapter_name
        when Symbol, String
          require "notifyor/growl/adapters/#{adapter_name}"
          @adapter = Notifyor::Growl::Adapters.const_get("#{adapter_name.to_s.split('_').collect(&:capitalize).join}")
        else
          raise "Missing adapter #{adapter_name}"
      end
    end

    def create_growl(title, message)
      adapter.create_growl(title, message)
    end

  end
end