module Pansophy
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'pansophy/tasks.rb'
    end
  end
end
