require 'terminal-notifier'
module Notifyor
  module Growl
    module Adapters
      module TerminalNotifier
        extend self

        def create_growl(title, message)
          ::TerminalNotifier.notify(message, :title => title)
        end

      end
    end
  end
end