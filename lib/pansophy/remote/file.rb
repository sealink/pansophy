module Pansophy
  module Remote
    class File
      include Adamantium::Flat

      def initialize(file)
        @file = file
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