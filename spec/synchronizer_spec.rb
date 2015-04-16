require 'spec_helper'

require 'pansophy'

describe Pansophy::Synchronizer do
  let(:connection) {
    Fog::Storage.new(
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                ENV['AWS_REGION']
    )
  }

  context 'when pulling a remote directory' do
    let(:bucket_name)       { 'test_app' }
    let(:remote_directory)  { 'config' }
    subject(:local_directory) {
      Pathname.new(__FILE__).dirname.expand_path.join('tmp')
    }
    let(:file_name) { 'test.yml' }
    let(:file_body) { { test: true }.to_yaml }
    let(:inner_file_1) { 'sub/inner1.txt' }
    let(:inner_file_2) { 'sub/inner2.txt' }
    let(:inner_file_1_body) { 'inner file 1' }
    let(:inner_file_2_body) { 'inner file 2' }

    let(:synchronizer) {
      Pansophy::Synchronizer.new(bucket_name, remote_directory, local_directory.to_s)
    }

    before do
      connection.put_bucket(bucket_name)
      connection.put_object(bucket_name, File.join(remote_directory, '/'), '')
      connection.put_object(bucket_name, File.join(remote_directory, file_name), file_body)
      connection.put_object(
        bucket_name,
        File.join(remote_directory, inner_file_1),
        inner_file_1_body
      )
      connection.put_object(
        bucket_name,
        File.join(remote_directory, inner_file_2),
        inner_file_2_body
      )
    end

    before do
      clean_path(subject)
    end
    after do
      clean_path(subject)
    end

    def clean_path(path)
      path.rmtree if path.exist?
    end

    shared_examples 'a synchronizer' do
      it { is_expected.to exist }
      specify do
        expect(subject.join(file_name)).to exist
      end
      specify do
        expect(subject.join(file_name).read).to eq file_body
      end
      specify do
        expect(subject.join(inner_file_1).read).to eq inner_file_1_body
      end
      specify do
        expect(subject.join(inner_file_2).read).to eq inner_file_2_body
      end
    end

    context 'when the local directory does not exist' do
      before do
        synchronizer.pull
      end
      it_behaves_like 'a synchronizer'
    end

    context 'when the local directory already exists' do
      before do
        local_directory.mkpath
      end

      context 'without passing the overwrite option' do
        let(:expected_error_message) {
          "#{local_directory} already exists, pass ':overwrite => true' to overwrite"
        }
        specify {
          expect { synchronizer.pull }
            .to raise_exception ArgumentError, expected_error_message
        }
      end

      context 'passing the overwrite option' do
        before do
          synchronizer.pull(overwrite: true)
        end
        it_behaves_like 'a synchronizer'
      end
    end
  end
end
