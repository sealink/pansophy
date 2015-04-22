module Pansophy
  module Remote
    class CreateFile
      include Adamantium::Flat

      def initialize(directory, path, body)
        @directory = directory
        @pathname  = Pathname.new(path)
        @body      = body
      end

      def call(options = {})
        prevent_overwrite! unless options[:overwrite]
        @directory.files.create(key: @pathname.to_s, body: @body.dup)
      end

      private

      def exist?
        @directory.files.any? { |file| file.key == @pathname.to_s }
      end

      def prevent_overwrite!
        return unless exist?
        fail ArgumentError,
             "#{@pathname} already exists, pass ':overwrite => true' to overwrite"
      end
    end
  end
end
