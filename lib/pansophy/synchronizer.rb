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
        file_path.dirname.mkpath
        File.open(file_path, 'w') do |f|
          f.write file.body
        end
      end
    end
  end
end
