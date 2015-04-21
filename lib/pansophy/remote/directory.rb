module Pansophy
  module Remote
    class Directory
      include Adamantium::Flat

      def initialize(bucket_name, path = nil)
        @bucket_name = bucket_name
        @path        = path.to_s
        verify_bucket!
      end

      def pathname
        Pathname.new(@path)
      end
      memoize :pathname

      def files
        remote_files.map { |file| File.new(file) }
      end

      private

      def directory
        Pansophy.connection.directories.get(@bucket_name, prefix: @path)
      end
      memoize :directory

      def remote_files
        directory.files.select { |file| !directory?(file) }
      end

      def directory?(file)
        file.key.end_with?('/')
      end

      def verify_bucket!
        return unless directory.nil?
        fail ArgumentError, "Could not find bucket #{@bucket_name}"
      end
    end
  end
end
