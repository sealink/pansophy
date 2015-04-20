module Pansophy
  class Synchronizer
    def initialize(bucket_name, remote_directory, local_directory)
      @remote = Remote::Directory.new(bucket_name, remote_directory)
      @local  = Local::Directory.new(local_directory)
    end

    def pull(options = {})
      @local.create(options)
      @remote.files.each do |file|
        file_path = @local.pathname.join(file.relative_path)
        Local::File.new(file_path, file.body).create
      end
    end
  end
end
