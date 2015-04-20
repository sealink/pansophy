module Pansophy
  module Remote
    class File
      include Adamantium::Flat

      def initialize(file, relative_directory = nil)
        @file      = file
        @directory = relative_directory
      end

      def body
        @file.body
      end

      def pathname
        Pathname.new(@file.key)
      end
      memoize :pathname
    end
  end
end