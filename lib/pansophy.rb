require 'pansophy/version'

module Pansophy
  def self.synchronize(bucket_name, remote_directory, local_directory, options = {})
    Synchronizer.new(bucket_name, remote_directory, local_directory).pull(options)
  end
end

require 'pansophy/synchronizer'
