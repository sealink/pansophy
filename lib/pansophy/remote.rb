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
      remote_files.map { |file| File.new(file, @directory_name) }
    end

    private

    def directory
      Pansophy.connection.directories.get(@bucket_name, prefix: @directory_name)
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

    class File
      include Adamantium::Flat

      def initialize(file, relative_directory = nil)
        @file      = file
        @directory = relative_directory
      end

      def body
        @file.body
      end

      def path
        Pathname.new(@file.key)
      end
      memoize :path

      def relative_path
        return self.path if @directory.to_s.empty?
        path.sub(::File.join(@directory.to_s, '/'), '')
      end
      memoize :relative_path
    end
  end
end
