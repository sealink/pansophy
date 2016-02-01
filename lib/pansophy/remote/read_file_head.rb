module Pansophy
  module Remote
    class ReadFileHead
      include Adamantium::Flat

      def initialize(bucket, path)
        @bucket   = bucket
        @pathname = Pathname.new(path)
      end

      def call
        fail ArgumentError, "#{@pathname} does not exist" if file.nil?
        file
      end

      private

      def file
        directory.files.head(@pathname.to_s)
      end
      memoize :file

      def directory
        ReadDirectory.new(@bucket, @pathname).call
      end
      memoize :directory
    end
  end
end
