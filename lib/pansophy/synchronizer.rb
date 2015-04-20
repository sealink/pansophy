module Pansophy
  class Synchronizer
    def initialize(bucket_name, remote_directory, local_directory)
      @remote_dir = Remote::Directory.new(bucket_name, remote_directory)
      @local_dir  = Local::Directory.new(local_directory)
    end

    def pull(options = {})
      @local_dir.create(options)
      @remote_dir.files.each do |file|
        file_path = Helpers::PathBuilder.new(file, @remote_dir, @local_dir).destination_path
        Local::File.new(file_path, file.body).create
      end
    end
  end
end
