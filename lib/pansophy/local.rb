module Pansophy
  class Local
    include Adamantium

    def initialize(directory_name)
      @directory_name = directory_name
      verify_directory!
    end

    def directory
      Pathname.new(@directory_name)
    end
    memoize :directory

    def create(options)
      remove(options)
      directory.mkpath
    end

    private

    def verify_directory!
      return if directory.directory? || !directory.exist?
      fail ArgumentError, "#{directory} is not a directory"
    end

    def remove(options)
      return unless directory.exist?
      prevent_overwrite! unless options[:overwrite]
      directory.rmtree
    end

    def prevent_overwrite!
      fail ArgumentError,
           "#{directory} already exists, pass ':overwrite => true' to overwrite"
    end
  end
end
