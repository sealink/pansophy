module Pansophy
  module Connection
    def self.aws
      Excon.defaults[:ciphers] = 'DEFAULT'
      Fog::Storage.new(
        provider:              'AWS',
        aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region:                ENV['AWS_REGION']
      )
    end
  end
end
