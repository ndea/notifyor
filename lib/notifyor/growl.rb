module Notifyor
  module Growl
    extend self

    def adapter
      return @adapter if @adapter
      self.adapter = :terminal_notifier
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

    def create_growl
      adapter.create_growl
    end

  end
end