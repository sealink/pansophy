module Pansophy
  class Remote
    include Adamantium::Flat

    attr_reader :directory_name

    def initialize(bucket_name, directory_name = nil)
      @bucket_name    = bucket_name
      @directory_name = directory_name.to_s
      verify_bucket!
    end

    def files
      directory.files.select { |file| !directory?(file) }.map { |file| File.new(file) }
    end

    private

    def directory
      Pansophy.connection.directories.get(@bucket_name, prefix: @directory_name)
    end
    memoize :directory

    def directory?(file)
      file.key.end_with?('/')
    end

    def verify_bucket!
      return unless directory.nil?
      fail ArgumentError, "Could not find bucket #{@bucket_name}"
    end

    class File
      include Adamantium::Flat

      def initialize(file)
        @file = file
      end

      def body
        @file.body
      end

      def path
        Pathname.new(@file.key)
      end

      def relative_to(path)
        return self.path if path.to_s.empty?
        Pathname.new(self.path.to_s.sub(::File.join(path.to_s, '/'), ''))
      end
    end
  end
end
