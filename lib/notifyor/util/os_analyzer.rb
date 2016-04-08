require 'rbconfig'
module Notifyor
  module Util
    module OSAnalyzer
      extend self
      def os
        host_os = RbConfig::CONFIG['host_os']
        case host_os
          when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
            :windows
          when /darwin|mac os/
            :macosx
          when /linux/
            :linux
          when /solaris|bsd/
            :unix
          else
            raise "unknown os: #{host_os.inspect}"
        end
      end
    end
  end
end
