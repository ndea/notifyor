module Notifyor
  module Growl
    module Adapters
      module TerminalNotifier
        extend self

        def create_growl
          %x(terminal-notifier -group 'address-book-sync' -title 'Address Book Sync' -subtitle 'Finished' -message 'Imported 42 contacts.' -activate 'com.apple.AddressBook')
        end

      end
    end
  end
end