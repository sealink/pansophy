$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'support/coverage_loader'

RSpec.configure do |config|
  config.before :each do
    Fog.mock!
    Fog::Mock.reset
  end
end

require 'dotenv'
Dotenv.load(Pathname.new(__FILE__).expand_path.dirname.join('.env.test'))

require 'pansophy'
