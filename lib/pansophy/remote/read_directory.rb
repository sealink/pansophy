module Pansophy
  module Remote
    class ReadDirectory
      include Adamantium::Flat

      def initialize(bucket, path)
        @bucket   = bucket
        @pathname = Pathname.new(path)
      end

      def call
        Pansophy.connection.directories.get(@bucket, prefix: @pathname.to_s).tap do |directory|
          fail ArgumentError, "Could not find bucket #{@bucket}" if directory.nil?
        end
      end
    end
  end
end