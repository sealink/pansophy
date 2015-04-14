require 'fog'

module Pansophy
  class Synchronizer
    def initialize(remote_directory, local_directory)
      @remote_directory = remote_directory
      @local_directory  = Pathname.new(local_directory)
      verify_local_directory!
    end

    def pull(options = {})
      verify_source!

      remove_target(options)

      source.files.each do |file|
        file_path = @local_directory.join(file.key)
        file_path.dirname.mkpath
        file_path.write(file.body)
      end
    end

    private

    def connection
      @connection ||=
        Fog::Storage.new(
          provider:              'AWS',
          aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
          aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
          region:                ENV['AWS_REGION']
        )
    end

    def verify_local_directory!
      return if @local_directory.directory? || !@local_directory.exist?
      fail ArgumentError, "#{@local_directory} is not a directory"
    end

    def source
      @source ||= connection.directories.get(@remote_directory)
    end

    def verify_source!
      return unless source.nil?
      fail ArgumentError, "Could not find remote directory #{@remote_directory}"
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
