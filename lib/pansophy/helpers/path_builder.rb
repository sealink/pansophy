module Pansophy
  module Helpers
    class PathBuilder
      def initialize(file, directory)
        @file      = file
        @directory = directory
      end

      def relative_path
        return @file.pathname if @directory.pathname.to_s.empty?
        @file.pathname.sub(::File.join(@directory.pathname, '/'), '')
      end
    end
  end
end
