module Pansophy
  module Connection
    def self.aws
      Excon.defaults[:ciphers] = 'DEFAULT'
      return env_fog if use_env_fog?
      iam_profile_fog
    end

    private

    def self.use_env_fog?
      ENV.include? 'AWS_ACCESS_KEY_ID'
    end

    def self.env_fog
      Fog::Storage.new(
        provider:              'AWS',
        aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region:                ENV['AWS_REGION']
      )
    end

    def self.iam_profile_fog
      Fog::Storage.new provider: 'AWS', use_iam_profile: true
    end
  end
end
