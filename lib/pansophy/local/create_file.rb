module Pansophy
  module Local
    class CreateFile
      include Adamantium::Flat

      def initialize(path, body)
        @pathname = Pathname.new(path)
        @body     = body
      end

      def call(options = {})
        prevent_overwrite! unless options[:overwrite]
        @pathname.dirname.mkpath
        ::File.write(@pathname, @body)
      end

      private

      def prevent_overwrite!
        return unless @pathname.exist?
        fail ArgumentError,
             "#{@pathname} already exists, pass ':overwrite => true' to overwrite"
      end
    end
  end
end
