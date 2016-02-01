require 'spec_helper'

require 'pansophy'

describe 'Reading a remote file' do
  let(:connection) {
    Fog::Storage.new(
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                ENV['AWS_REGION']
    )
  }

  let(:bucket_name) { 'test_app' }
  let(:path) { 'files/test.txt' }
  let(:body) { 'Content' }

  let(:read_file) { Pansophy::Remote::ReadFile.new(bucket_name, path) }

  context 'when the bucket exists' do
    before do
      connection.put_bucket(bucket_name)
    end

    context 'when the file exists' do
      before do
        connection.put_object(bucket_name, path, body)
      end

      specify do
        expect(read_file.call).to eq body
      end

      context 'when using the module level interface' do
        specify do
          expect(Pansophy.read(bucket_name, path)).to eq body
        end
      end

      context 'when reading the file head' do
        shared_examples 'a file head' do
          specify { expect(file_head.key).to eq path }
          specify { expect(file_head.content_length).to eq body.length }
          specify { expect(file_head.content_type).to be_nil }
          specify { expect(file_head.etag).to match /\h{32}$/ }
          specify { expect(file_head.last_modified).to be_within(1).of Time.now }
        end

        let(:read_file_head) { Pansophy::Remote::ReadFileHead.new(bucket_name, path) }
        subject(:file_head) { read_file_head.call }
        it_behaves_like 'a file head'

        context 'when using the module level interface' do
          subject(:file_head) { Pansophy.head(bucket_name, path) }
          it_behaves_like 'a file head'
        end
      end
    end

    context 'when the file does not exist' do
      specify do
        expect { read_file.call }.to raise_error ArgumentError, "#{path} does not exist"
      end
    end
  end

  context 'when the bucket exists' do
    specify do
      expect { read_file.call }.to raise_error ArgumentError, "Could not find bucket #{bucket_name}"
    end
  end
end
