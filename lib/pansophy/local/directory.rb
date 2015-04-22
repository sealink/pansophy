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

      def files
        entries.select(&:file?).map { |file| File.new(file) }
      end

      def create(options)
        remove(options)
        pathname.mkpath
      end

      def create_file(path, body, options = {})
        CreateFile.new(pathname.join(path), body).call(options)
      end

      private

      def entries
        Dir[pathname.join('**/*')].map { |entry| Pathname.new(entry) }
      end
      memoize :entries

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
