require 'spec_helper'

require 'pansophy'

describe Pansophy::ConfigSynchronizer do
  subject(:synchronizer) { Pansophy::ConfigSynchronizer.new }

  context 'when pulling/merging a remote directory' do
    context 'when values are set explicitly' do
      before do
        subject.config_bucket_name   = 'bucket'
        subject.config_remote_folder = 'remote_config'
        subject.config_local_folder  = 'local_config'
        subject.version              = '1.5'
      end

      it 'should syncronize with these values' do
        expect(Pansophy)
          .to receive(:merge)
          .with('bucket', 'remote_config/1.5', 'local_config', overwrite: true)
        subject.pull
      end
    end

    context 'when values are not specified' do
      before do
        subject.config_bucket_name   = 'bucket'
      end

      it 'should syncronize with these values' do
        expect(Pansophy)
          .to receive(:merge)
          .with('bucket', 'config/1.0', 'config', overwrite: true)
        subject.pull
      end
    end

    context 'where rails is defined' do
      before do
        Rails = Class.new do
          def self.root
            Pathname.new('/rails/root')
          end
        end
        subject.config_bucket_name   = 'bucket'
      end

      it 'should syncronize with these values' do
        expect(Pansophy)
          .to receive(:merge)
          .with('bucket', 'config/1.0', '/rails/root/config', overwrite: true)
        subject.pull
      end
    end
  end
end
