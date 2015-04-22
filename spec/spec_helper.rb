$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

MINIMUM_COVERAGE = 100

if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-rcov'
  require 'coveralls'
  Coveralls.wear!

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::RcovFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter '/vendor/'
    add_filter '/spec/'
    add_group 'lib', 'lib'
  end
  SimpleCov.at_exit do
    SimpleCov.result.format!
    percent = SimpleCov.result.covered_percent
    unless percent >= MINIMUM_COVERAGE
      puts "Coverage must be above #{MINIMUM_COVERAGE}%. It is #{format('%.2f', percent)}%"
      Kernel.exit(1)
    end
  end
end

RSpec.configure do |config|
  config.before :each do
    Fog.mock!
    Fog::Mock.reset
  end
end

require 'dotenv'
Dotenv.load(Pathname.new(__FILE__).expand_path.dirname.join('.env.test'))

require 'pansophy'
