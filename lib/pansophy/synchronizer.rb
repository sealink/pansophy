module Pansophy
  class Synchronizer
    def initialize(bucket_name, remote_directory, local_directory)
      @bucket_name      = bucket_name
      @remote_directory = remote_directory.to_s
      @local_directory  = Pathname.new(local_directory)
      verify_local_directory!
    end

    def pull(options = {})
      verify_source!

      remove_target(options)

      source.files.each do |file|
        next if directory?(file)
        file_path = @local_directory.join(destination_for(file))
        file_path.dirname.mkpath
        File.open(file_path, 'w') do |f|
          f.write file.body
        end
      end
    end

    private

    def verify_local_directory!
      return if @local_directory.directory? || !@local_directory.exist?
      fail ArgumentError, "#{@local_directory} is not a directory"
    end

    def destination_for(file)
      return file.key if @remote_directory.empty?
      file.key.sub(File.join(@remote_directory, '/'), '')
    end

    def directory?(file)
      file.key.end_with?('/')
    end

    def source
      @source ||= Pansophy.connection.directories.get(@bucket_name, prefix: @remote_directory)
    end

    def verify_source!
      return unless source.nil?
      fail ArgumentError, "Could not find bucket #{@bucket_name}"
    end

    def remove_target(options)
      return unless @local_directory.exist?
      unless options[:overwrite]
        fail ArgumentError,
             "#{@local_directory} already exists, pass ':overwrite => true' to overwrite"
      end
      @local_directory.rmtree
    end
  end
end
