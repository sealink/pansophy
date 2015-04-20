module Pansophy
  module Local
    class File
      include Adamantium::Flat

      attr_reader :pathname, :body

      def initialize(path, body)
        @pathname = Pathname.new(path)
        @body     = body
      end

      def create(options = {})
        prevent_overwrite! unless options[:overwrite]
        @pathname.dirname.mkpath
        ::File.open(@pathname, 'w') do |f|
          f.write @body
        end
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