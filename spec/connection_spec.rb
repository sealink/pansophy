require 'spec_helper'

describe Pansophy::Connection do
  subject { described_class }

  context 'when using an EC2 profile' do
    before do
      stub_const 'Excon', double(defaults: { })
      allow(ENV).to receive(:include?).and_call_original
      allow(ENV).to receive(:include?).with('AWS_ACCESS_KEY_ID').and_return(false)
      allow(Fog::Storage).to receive(:new)
      subject.aws
    end

    it 'uses the correct option' do
      expect(Fog::Storage).to have_received(:new).with(
        use_iam_profile: true,
        provider: 'AWS'
      )
    end
  end
end
