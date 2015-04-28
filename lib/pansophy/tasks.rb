namespace :config do
  desc "Synchronize config files from remote folder"
  task :synchronize do
    require 'pansophy/config_synchronizer'
    require 'dotenv'
    Dotenv.load
    Pansophy::ConfigSynchronizer.new.pull
  end
end
