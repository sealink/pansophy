module Pansophy
  module Remote
    class ReadFileBody
      include Adamantium::Flat

      def initialize(bucket, path)
        @bucket   = bucket
        @pathname = Pathname.new(path)
      end

      def call
        file.body
      end

      private

      def file
        FetchFile.new(@bucket, @pathname).call
      end
      memoize :file
    end
  end
end
