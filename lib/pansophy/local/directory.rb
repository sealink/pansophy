module Pansophy
  module Local
    class Directory
      include Adamantium

      def initialize(path)
        @path = path
        verify_directory!
      end

      def pathname
        Pathname.new(@path)
      end
      memoize :pathname

      def create(options)
        remove(options)
        pathname.mkpath
      end

      def create_file(path, body, options = {})
        CreateFile.new(pathname.join(path), body).call(options)
      end

      private

      def verify_directory!
        return if pathname.directory? || !pathname.exist?
        fail ArgumentError, "#{pathname} is not a directory"
      end

      def remove(options)
        return unless pathname.exist?
        prevent_overwrite! unless options[:overwrite]
        pathname.rmtree
      end

      def prevent_overwrite!
        fail ArgumentError,
             "#{pathname} already exists, pass ':overwrite => true' to overwrite"
      end
    end
  end
end
