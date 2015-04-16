module Pansophy
  class Synchronizer
    def initialize(bucket_name, remote_directory, local_directory)
      @remote = Remote.new(bucket_name, remote_directory)
      @local  = Local.new(local_directory)
    end

    def pull(options = {})
      @local.create(options)
      @remote.files.each do |file|
        file_path = @local.directory.join(file.relative_to(@remote.directory_name))
        file_path.dirname.mkpath
        File.open(file_path, 'w') do |f|
          f.write file.body
        end
      end
    end
  end
end
