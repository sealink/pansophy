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

      def path
        Pathname.new(@file.key)
      end
      memoize :path

      def relative_path
        return self.path if @directory.to_s.empty?
        path.sub(::File.join(@directory.to_s, '/'), '')
      end
      memoize :relative_path
    end
  end
end