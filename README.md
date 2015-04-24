# Pansophy

[![Gem Version](https://badge.fury.io/rb/pansophy.svg)](http://badge.fury.io/rb/pansophy)
[![Build Status](https://travis-ci.org/sealink/pansophy.svg?branch=master)](https://travis-ci.org/sealink/pansophy)
[![Coverage Status](https://coveralls.io/repos/sealink/pansophy/badge.svg)](https://coveralls.io/r/sealink/pansophy)
[![Dependency Status](https://gemnasium.com/sealink/pansophy.svg)](https://gemnasium.com/sealink/pansophy)
[![Code Climate](https://codeclimate.com/github/sealink/pansophy/badges/gpa.svg)](https://codeclimate.com/github/sealink/pansophy)

Pansophy allows different applications to share knowledge via a centralised remote repository

The current version only works wit AWS S3 buckets and allows:
  * pulling a remote directory to a local directory
  * merging a remote directory with a local directory
  * pushing a local directory to a remote directory
  * reading the contents of a remote file

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pansophy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pansophy

## Usage

To pull a remote directory to a local directory
```ruby
# Pass overwrite: true to entirely replace the local directory.
Pansophy.pull('bucket_name', 'remote_directory', 'local_directory', overwrite: true)
```

To merge a remote directory with a local directory
```ruby
# Pass overwrite: true to entirely replace the remote directory.
Pansophy.merge('bucket_name', 'remote_directory', 'local_directory', overwrite: true)
```

To push a local directory to a remote directory
```ruby
# Pass overwrite: true to overwrite local files with remote files.
# Local files without a corresponding remote file remain untouched.
Pansophy.push('bucket_name', 'remote_directory', 'local_directory', overwrite: true)
```

To read the contents of a remote file
```ruby
Pansophy.read('bucket_name', 'remote_file_path')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/sealink/pansophy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
