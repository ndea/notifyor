module Notifyor
  module Growl
    module Adapters
      module LibnotifyNotifier
        extend self

        def create_growl(title, message)
          %x(notify-send '#{title}' '#{message}')
        end

      end
    end
  end
end