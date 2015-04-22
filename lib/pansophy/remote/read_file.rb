module Pansophy
  module Remote
    class ReadFile
      include Adamantium::Flat

      def initialize(bucket, path)
        @bucket   = bucket
        @pathname = Pathname.new(path)
      end

      def call
        fail ArgumentError, "#{@pathname} does not exist" if file.nil?
        file.body
      end

      private

      def file
        directory.files.find { |file| file.key == @pathname.to_s }
      end
      memoize :file

      def directory
        ReadDirectory.new(@bucket, @pathname).call
      end
      memoize :directory
    end
  end
end
