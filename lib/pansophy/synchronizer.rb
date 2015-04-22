module Pansophy
  class Synchronizer
    def initialize(bucket_name, remote_directory, local_directory)
      @remote_dir = Remote::Directory.new(bucket_name, remote_directory)
      @local_dir  = Local::Directory.new(local_directory)
    end

    def pull(options = {})
      synchronize(@remote_dir, @local_dir, options)
    end

    def push(options = {})
      synchronize(@local_dir, @remote_dir, options)
    end

    private

    def synchronize(source_dir, destination_dir, options)
      destination_dir.create(options)
      source_dir.files.each do |file|
        file_path = Helpers::PathBuilder.new(file, source_dir).relative_path
        destination_dir.create_file(file_path, file.body, options)
      end
    end
  end
end
