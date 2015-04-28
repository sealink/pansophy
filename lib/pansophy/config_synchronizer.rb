require 'pansophy'
require 'facets/kernel/blank'

class ConfigSynchronizer
  include Memoizable

  def pull
    verify_app_name!
    Pansophy.pull(app_name, remote_path, local_path, overwrite: true)
  end

  private

  def app_name
    ENV['AUDITOR_APP_NAME']
  end
  memoize :app_name

  def remote_path
    Pathname.new('config').join(version.to_s)
  end

  def version
    ENV['CONFIG_VERSION'] || '1.0'
  end

  def local_path
    Pathname.new(__FILE__).expand_path.join('../../config')
  end

  def verify_app_name!
    fail ArgumentError, "AUDITOR_APP_NAME is undefined" if app_name.blank?
  end
end
