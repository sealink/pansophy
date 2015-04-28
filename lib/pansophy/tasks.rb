namespace :config do
  desc "Synchronize config files from pansophy"
  task :synchronize do
    require 'pansophy/config_synchronizer'
    require 'dotenv'
    Dotenv.load
    ConfigSynchronizer.new.pull
  end
end
