module Pansophy
  class Synchronizer
    def initialize(bucket_name, remote_directory, local_directory)
      @remote = Remote.new(bucket_name, remote_directory)
      @local  = Local.new(local_directory)
    end

    def pull(options = {})
      remove_target(options)

      @remote.files.each do |file|
        file_path = @local.directory.join(file.relative_to(@remote.directory_name))
        file_path.dirname.mkpath
        File.open(file_path, 'w') do |f|
          f.write file.body
        end
      end
    end

    private

    def remove_target(options)
      return unless @local.directory.exist?
      unless options[:overwrite]
        fail ArgumentError,
             "#{@local.directory} already exists, pass ':overwrite => true' to overwrite"
      end
      @local.directory.rmtree
    end
  end
end
