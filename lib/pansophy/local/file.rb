module Pansophy
  module Local
    class File
      include Adamantium::Flat

      attr_reader :pathname

      def initialize(path)
        @pathname = Pathname.new(path)
      end

      def body
        return nil unless @pathname.exist?
        ::File.read(@pathname)
      end
      memoize :body
    end
  end
end