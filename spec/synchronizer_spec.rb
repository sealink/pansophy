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

  let(:bucket_name) { 'test_app' }
  let(:remote_directory) { Pathname.new('config') }
  let(:local_directory_name) { 'tmp' }
  let(:local_directory) { Pathname.new(__FILE__).dirname.expand_path.join(local_directory_name) }
  let(:file_name) { 'test.yml' }
  let(:file_body) { { test: true }.to_yaml }
  let(:inner_file_1) { 'sub/inner1.txt' }
  let(:inner_file_2) { 'sub/inner2.txt' }
  let(:inner_file_1_body) { 'inner file 1' }
  let(:inner_file_2_body) { 'inner file 2' }

  let(:synchronizer) {
    Pansophy::Synchronizer.new(bucket_name, remote_directory.to_s, local_directory.to_s)
  }

  before do
    clean_path(local_directory)
  end

  after do
    clean_path(local_directory)
  end

  def clean_path(path)
    path.rmtree if path.exist?
  end

  def create_bucket
    connection.put_bucket(bucket_name)
  end

  def create_remote_directory
    connection.put_object(bucket_name, File.join(remote_directory.to_s, '/'), '')
  end

  def create_remote_file(path, body)
    connection.put_object(bucket_name, remote_directory.join(path).to_s, body)
  end

  def get_remote_file(path)
    connection.get_object(bucket_name, remote_directory.join(path).to_s)
  end

  context 'when pulling a remote directory' do
    before do
      create_bucket
      create_remote_directory
      create_remote_file(file_name, file_body)
      create_remote_file(inner_file_1, inner_file_1_body)
      create_remote_file(inner_file_2, inner_file_2_body)
    end

    shared_examples 'a synchronised local folder' do
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

    subject { local_directory }

    context 'when the local directory does not exist' do
      before do
        synchronizer.pull
      end
      it_behaves_like 'a synchronised local folder'
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
        it_behaves_like 'a synchronised local folder'
      end
    end

    context 'when the local directory already exists as a file' do
      let(:local_directory_name) { 'tmp/test' }
      let(:body) { 'TEST' }

      before do
        local_directory.dirname.mkpath
        ::File.open(local_directory, 'w') do |f|
          f.write body
        end
      end

      specify {
        expect { synchronizer.pull }
          .to raise_exception ArgumentError, "#{local_directory} is not a directory"
      }
    end
  end

  context 'when pushing a local directory' do
    let(:files) {
      {
        file_name    => file_body,
        inner_file_1 => inner_file_1_body,
        inner_file_2 => inner_file_2_body
      }
    }
    before do
      files.each do |path, body|
        full_path = local_directory.join(path)
        full_path.dirname.mkpath
        ::File.open(full_path, 'w') do |f|
          f.write body
        end
      end
    end

    let(:remote_file) { get_remote_file(file_name) }
    let(:remote_inner_file_1) { get_remote_file(inner_file_1) }
    let(:remote_inner_file_2) { get_remote_file(inner_file_2) }

    shared_examples 'a synchronised remote folder' do
      specify do
        expect(remote_file.body).to eq file_body
      end
      specify do
        expect(remote_inner_file_1.body).to eq inner_file_1_body
      end
      specify do
        expect(remote_inner_file_2.body).to eq inner_file_2_body
      end
    end

    context 'when the bucket does not exist' do
      specify {
        expect { synchronizer.push }
          .to raise_exception ArgumentError, "Could not find bucket #{bucket_name}"
      }
    end

    context 'when the bucket exists' do
      before do
        create_bucket
      end

      before do
        synchronizer.push
      end

      it_behaves_like 'a synchronised remote folder'
    end

    context 'when the remote directory already exists' do
      before do
        create_bucket
        create_remote_directory
      end

      context 'without passing the overwrite option' do
        let(:expected_error_message) {
          "#{remote_directory} already exists, pass ':overwrite => true' to overwrite"
        }
        specify {
          expect { synchronizer.push }
            .to raise_exception ArgumentError, expected_error_message
        }
      end

      context 'passing the overwrite option' do
        before do
          synchronizer.push(overwrite: true)
        end
        it_behaves_like 'a synchronised remote folder'
      end
    end
  end

  context 'when using the module level interface' do
    let(:synchronizer_class) { double(new: synchronizer) }
    let(:synchronizer) { double }

    before do
      stub_const 'Pansophy::Synchronizer', synchronizer_class
    end

    context 'when pulling' do
      before do
        allow(synchronizer).to receive(:pull)
        Pansophy.pull('bucket_name', 'remote_directory', 'local_directory', overwrite: true)
      end

      specify do
        expect(synchronizer_class).to have_received(:new)
          .with('bucket_name', 'remote_directory', 'local_directory')
      end

      specify do
        expect(synchronizer).to have_received(:pull).with(overwrite: true)
      end
    end

    context 'when pushing' do
      before do
        allow(synchronizer).to receive(:push)
        Pansophy.push('bucket_name', 'remote_directory', 'local_directory', overwrite: true)
      end

      specify do
        expect(synchronizer_class).to have_received(:new)
          .with('bucket_name', 'remote_directory', 'local_directory')
      end

      specify do
        expect(synchronizer).to have_received(:push).with(overwrite: true)
      end
    end
  end

  describe Pansophy::Local::CreateFile do
    let(:folder) {
      Pathname.new(__FILE__).dirname.expand_path.join('tmp')
    }
    let(:path) { local_directory.join(file_name) }
    let(:create_file) { Pansophy::Local::CreateFile.new(path, file_body) }

    specify do
      expect(path).not_to exist
    end

    context 'when creating a file' do
      before do
        create_file.call
      end

      specify do
        expect(path).to exist
      end

      specify do
        expect(path.read).to eq file_body
      end

      context 'when the file already exists' do
        let(:new_file_body) { 'New content' }
        let(:new_create_file) { Pansophy::Local::CreateFile.new(path, new_file_body) }

        context 'without passing the overwrite option' do
          let(:expected_error_message) {
            "#{path} already exists, pass ':overwrite => true' to overwrite"
          }

          specify do
            expect { new_create_file.call }.to raise_error ArgumentError, expected_error_message
          end
        end

        context 'passing the overwrite option' do
          before do
            new_create_file.call(overwrite: true)
          end

          specify do
            expect(path.read).to eq new_file_body
          end
        end
      end
    end
  end

  describe Pansophy::Remote::CreateFile do
    let(:path) { 'created_files/test.txt' }
    let(:full_path) { remote_directory.join(path) }
    let(:body) { 'Content' }
    let(:create_file) { Pansophy::Remote::CreateFile.new(bucket_name, full_path, body) }

    before do
      create_bucket
      create_remote_directory
    end

    context 'when creating a file' do
      let(:created_file) { get_remote_file(path) }

      before do
        create_file.call
      end

      specify do
        expect(created_file.body).to eq body
      end

      context 'when the file already exists' do
        let(:new_body) { 'New content' }
        let(:new_create_file) { Pansophy::Remote::CreateFile.new(bucket_name, full_path, new_body) }

        context 'without passing the overwrite option' do
          let(:expected_error_message) {
            "#{full_path} already exists, pass ':overwrite => true' to overwrite"
          }

          specify do
            expect { new_create_file.call }.to raise_error ArgumentError, expected_error_message
          end
        end

        context 'passing the overwrite option' do
          before do
            new_create_file.call(overwrite: true)
          end

          specify do
            expect(created_file.body).to eq new_body
          end
        end
      end
    end
  end
end
