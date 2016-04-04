module Notifyor
  module Growl
    module Adapters
      module TerminalNotifier
        extend self

        def create_growl(title, message)
          %x(terminal-notifier -title '#{title}' -message '#{message}')
        end

      end
    end
  end
end