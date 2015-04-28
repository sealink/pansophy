require 'pansophy'
require 'facets/kernel/blank'

module Pansophy
  class ConfigSynchronizer
    attr_accessor :config_bucket_name, :config_remote_folder, :config_local_folder, :version

    def pull
      puts "Fetching remote configuration (version #{VERSION})"
      verify_config_bucket_name!
      Pansophy.merge(config_bucket_name, remote_path, local_path, overwrite: true)
      puts 'done'
    end

    private

    def config_bucket_name
      @config_bucket_name ||= ENV['CONFIG_BUCKET_NAME']
    end

    def config_remote_folder
      @config_remote_folder ||= (ENV['CONFIG_REMOTE_FOLDER'] || 'config')
    end

    def config_local_folder
      @config_local_folder ||= (ENV['CONFIG_LOCAL_FOLDER'] || RootPathFinder.find || 'config')
    end

    def version
      @version ||= (ENV['CONFIG_VERSION'] || '1.0')
    end

    def remote_path
      Pathname.new(config_remote_folder).join(version.to_s).to_s
    end

    def local_path
      config_local_folder.to_s
    end

    def verify_config_bucket_name!
      fail ArgumentError, "CONFIG_BUCKET_NAME is undefined" if config_bucket_name.blank?
    end
  end

  class RootPathFinder
    def self.find
      return Rails.root.join('config') if defined?(Rails)
    end
  end
end
