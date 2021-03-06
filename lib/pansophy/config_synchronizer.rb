require 'pansophy'

module Pansophy
  class ConfigSynchronizer
    attr_writer :config_bucket_name, :config_remote_folder, :config_local_folder, :version

    def merge
      verify_config_bucket_name!
      Pansophy.merge(config_bucket_name, remote_path, local_path, overwrite: true)
    end

    def config_bucket_name
      @config_bucket_name ||= ENV['CONFIG_BUCKET_NAME']
    end

    def config_remote_folder
      @config_remote_folder ||= ENV.fetch('CONFIG_REMOTE_FOLDER', 'config')
    end

    def config_local_folder
      @config_local_folder ||= (ENV['CONFIG_LOCAL_FOLDER'] || ConfigPath.find!)
    end

    def version
      @version ||= ENV.fetch('CONFIG_VERSION', '1.0')
    end

    private

    def remote_path
      Pathname.new(config_remote_folder).join(version.to_s).to_s
    end

    def local_path
      config_local_folder.to_s
    end

    def verify_config_bucket_name!
      return unless config_bucket_name.nil? || config_bucket_name.empty?
      fail ConfigSynchronizerError, 'CONFIG_BUCKET_NAME is undefined'
    end
  end

  class ConfigPath
    def self.find!
      # TODO: Extract this in a Rails specific gem
      return Rails.root.join('config') if defined?(Rails)
      return sinatra_root_pathname.join('config') if defined?(Sinatra::Application)

      fail ConfigSynchronizerError, 'Could not determine location of config folder'
    end

    private

    def self.sinatra_root_pathname
      Pathname.new(Sinatra::Application.settings.root)
    end
  end

  class ConfigSynchronizerError < StandardError
  end
end
