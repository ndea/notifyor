module Notifyor
  module Util
    module Formatter
      extend self

      def squish!(string)
        string.gsub!(/\A[[:space:]]+/, '')
        string.gsub!(/[[:space:]]+\z/, '')
        string.gsub!(/[[:space:]]+/, ' ')
        string
      end

    end
  end
end