module Pansophy
  module Remote
    class CreateFile
      include Adamantium::Flat

      ALLOWED_ATTRS = %i[
        cache_control
        content_disposition
        content_encoding
        content_length
        content_md5
        content_type
        etag
        expires
        last_modified
        metadata
        owner
        storage_class
        encryption
        encryption_key
        version
      ].freeze

      def initialize(bucket, path, body)
        @bucket   = bucket
        @pathname = Pathname.new(path)
        @body     = body
      end

      def call(options = {})
        prevent_overwrite! unless options[:overwrite]
        params = options.slice(*ALLOWED_ATTRS).merge(key: @pathname.to_s, body: @body.dup)
        directory.files.create(params)
      end

      private

      def exist?
        directory.files.any? { |file| file.key == @pathname.to_s }
      end

      def prevent_overwrite!
        return unless exist?
        fail ArgumentError,
             "#{@pathname} already exists, pass ':overwrite => true' to overwrite"
      end

      def directory
        ReadDirectory.new(@bucket, @pathname).call
      end
      memoize :directory
    end
  end
end
