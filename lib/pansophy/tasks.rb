namespace :config do
  desc 'Synchronize config files from remote folder'
  task :synchronize do
    require 'pansophy/config_synchronizer'
    require 'dotenv'
    Dotenv.load
    synchronizer = Pansophy::ConfigSynchronizer.new
    puts "Fetching remote configuration (version #{synchronizer.version})"
    synchronizer.merge
    puts done
  end
end
