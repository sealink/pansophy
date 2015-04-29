require 'spec_helper'

require 'pansophy'

describe Pansophy::ConfigSynchronizer do
  subject(:config_synchronizer) { Pansophy::ConfigSynchronizer.new }

  before do
    allow(Pansophy).to receive(:merge)
  end

  context 'when the configuration attributes are set explicitly' do
    before do
      config_synchronizer.config_bucket_name   = 'bucket'
      config_synchronizer.config_remote_folder = 'remote_config'
      config_synchronizer.config_local_folder  = 'local_config'
      config_synchronizer.version              = '1.5'
    end

    context 'when merging the remote config directory' do
      before do
        config_synchronizer.merge
      end

      specify do
        expect(Pansophy).to have_received(:merge).with(
          'bucket',
          'remote_config/1.5',
          'local_config',
          overwrite: true
        )
      end
    end
  end

  context 'when the configuration attributes are specified via environment variables' do
    before do
      ENV['CONFIG_BUCKET_NAME']   = 'bucket'
      ENV['CONFIG_REMOTE_FOLDER'] = 'remote_config'
      ENV['CONFIG_LOCAL_FOLDER']  = 'local_config'
      ENV['CONFIG_VERSION']       = '1.5'
    end

    after do
      ENV['CONFIG_BUCKET_NAME']   = nil
      ENV['CONFIG_REMOTE_FOLDER'] = nil
      ENV['CONFIG_LOCAL_FOLDER']  = nil
      ENV['CONFIG_VERSION']       = nil
    end

    context 'when merging the remote config directory' do
      before do
        config_synchronizer.merge
      end

      specify do
        expect(Pansophy).to have_received(:merge).with(
          'bucket',
          'remote_config/1.5',
          'local_config',
          overwrite: true
        )
      end
    end
  end

  context 'when the bucket name is not specified' do
    before do
      config_synchronizer.config_local_folder = 'local_config'
    end

    context 'when merging the remote config directory' do
      specify do
        expect { config_synchronizer.merge }
          .to raise_error Pansophy::ConfigSynchronizerError,
                          'CONFIG_BUCKET_NAME is undefined'
      end
    end
  end

  context 'when the local folder is not specified' do
    before do
      config_synchronizer.config_bucket_name = 'bucket'
    end

    context 'when merging the remote config directory' do
      specify do
        expect { config_synchronizer.merge }
          .to raise_error Pansophy::ConfigSynchronizerError,
                          'Could not determine location of config folder'
      end
    end
  end

  context 'when the remote folder and the version are not specified' do
    before do
      config_synchronizer.config_bucket_name  = 'bucket'
      config_synchronizer.config_local_folder = 'local_config'
    end

    context 'when merging the remote config directory' do
      before do
        config_synchronizer.merge
      end

      it 'should use default values' do
        expect(Pansophy)
          .to have_received(:merge).with('bucket', 'config/1.0', 'local_config', overwrite: true)
      end
    end
  end

  context 'when rails is defined' do
    let(:rails) { double(root: Pathname.new('rails/root')) }

    before do
      stub_const('Rails', rails)
    end

    context 'when only the bucket name is specified' do
      before do
        config_synchronizer.config_bucket_name = 'bucket'
      end

      context 'when merging the remote config directory' do
        before do
          config_synchronizer.merge
        end

        it 'should use rails config folder as the local folder' do
          expect(Pansophy).to have_received(:merge).with(
            'bucket',
            'config/1.0',
            'rails/root/config',
            overwrite: true
          )
        end
      end
    end
  end
end