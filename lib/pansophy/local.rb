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

    private

    def verify_directory!
      return if directory.directory? || !directory.exist?
      fail ArgumentError, "#{directory} is not a directory"
    end
  end
end
