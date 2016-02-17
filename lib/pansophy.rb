require 'pansophy/version'

module Pansophy
  def self.connection
    @connection ||= Connection.aws
  end

  def self.pull(bucket_name, remote_directory, local_directory, options = {})
    Synchronizer.new(bucket_name, remote_directory, local_directory).pull(options)
  end

  def self.merge(bucket_name, remote_directory, local_directory, options = {})
    Synchronizer.new(bucket_name, remote_directory, local_directory).merge(options)
  end

  def self.push(bucket_name, remote_directory, local_directory, options = {})
    Synchronizer.new(bucket_name, remote_directory, local_directory).push(options)
  end

  def self.fetch(bucket_name, path)
    Remote::FetchFile.new(bucket_name, path).call
  end

  def self.read(bucket_name, path)
    Remote::ReadFileBody.new(bucket_name, path).call
  end

  def self.head(bucket_name, path)
    Remote::ReadFileHead.new(bucket_name, path).call
  end
end

require 'fog/aws'
require 'singleton'
require 'adamantium'

require 'pansophy/helpers'
require 'pansophy/connection'
require 'pansophy/remote'
require 'pansophy/local'
require 'pansophy/synchronizer'
require 'pansophy/config_synchronizer'
require 'pansophy/railtie' if defined?(Rails)
