require 'spec_helper'

require 'pansophy'

describe Pansophy::ConfigSynchronizer do
  subject(:config_synchronizer) { Pansophy::ConfigSynchronizer.new }

  let(:synchronizer_class) { double(new: synchronizer) }
  let(:synchronizer) { double }

  before do
    stub_const('Pansophy::Synchronizer', synchronizer_class)
    allow(synchronizer).to receive(:merge)
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
        expect(synchronizer_class)
          .to have_received(:new).with('bucket', 'remote_config/1.5', 'local_config')
      end

      specify do
        expect(synchronizer).to have_received(:merge).with(overwrite: true)
      end
    end
  end

  context 'when the configuration attributes are specified via environment variables' do
    let(:config_bucket_name)    { 'bucket' }
    let(:config_remote_folder)  { 'remote_config' }
    let(:config_local_folder)   { 'local_config' }
    let(:config_version)        { '1.5' }

    before do
      ENV['CONFIG_BUCKET_NAME']   = config_bucket_name
      ENV['CONFIG_REMOTE_FOLDER'] = config_remote_folder
      ENV['CONFIG_LOCAL_FOLDER']  = config_local_folder
      ENV['CONFIG_VERSION']       = config_version
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

      context 'when all attributes are present' do
        specify do
          expect(synchronizer_class)
            .to have_received(:new).with('bucket', 'remote_config/1.5', 'local_config')
        end

        specify do
          expect(synchronizer).to have_received(:merge).with(overwrite: true)
        end
      end

      context 'when some attributes are not present' do
        let(:config_bucket_name)    { 'bucket' }
        let(:config_remote_folder)  { '' }
        let(:config_local_folder)   { 'local_config' }
        let(:config_version)        { '' }

        specify do
          expect(synchronizer_class).to have_received(:new).with('bucket', '.', 'local_config')
        end

        specify do
          expect(synchronizer).to have_received(:merge).with(overwrite: true)
        end
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
        expect(synchronizer_class)
          .to have_received(:new).with('bucket', 'config/1.0', 'local_config')
      end

      specify do
        expect(synchronizer).to have_received(:merge).with(overwrite: true)
      end
    end
  end

  context 'when only the bucket name is specified' do
    before do
      config_synchronizer.config_bucket_name = 'bucket'
    end

    context 'when merging the remote config directory and using rails' do
      let(:rails) { double(root: Pathname.new('rails/root')) }

      before do
        stub_const('Rails', rails)
        config_synchronizer.merge
      end

      it 'should use rails config folder as the local folder' do
        expect(synchronizer_class)
          .to have_received(:new).with('bucket', 'config/1.0', 'rails/root/config')
      end

      specify do
        expect(synchronizer).to have_received(:merge).with(overwrite: true)
      end
    end

    context 'when merging the remote config directory and using sinatra' do
      let(:sinatra) { double(settings: double(root: 'sinatra/root')) }

      before do
        stub_const('Sinatra::Application', sinatra)
        config_synchronizer.merge
      end

      it 'should use the sinatra config folder as the local folder' do
        expect(synchronizer_class)
          .to have_received(:new).with('bucket', 'config/1.0', 'sinatra/root/config')
      end

      specify do
        expect(synchronizer).to have_received(:merge).with(overwrite: true)
      end
    end
  end
end
