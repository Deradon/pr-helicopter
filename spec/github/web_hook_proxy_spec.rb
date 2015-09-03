require 'github/web_hook_proxy'

RSpec.describe Github::WebHookProxy do
  it_behaves_like 'a Github::Proxy'

  describe '.resource' do
    subject { described_class.resource }
    it { is_expected.to be_subclass_of(Github::WebHook) }
  end

  context 'when adding a web hook' do
    let(:proxy) { described_class.new repo: 'w/w', secret: '' }
    subject { double(proxy.resource, create: nil) }

    before do
      allow(subject).to receive(:create).and_return(nil)
      allow(proxy).to receive(:resource).and_return(subject)
      proxy.add 'callback', events: ['event']
    end

    it do
      expect(subject).to have_received(:create).with(
        repo: 'w/w', secret: '', callback: 'callback', events: ['event'])
    end
  end

  context 'when deleting a web hook' do
    let(:proxy) { described_class.new repo: 'w/w', secret: '' }
    subject { instance_double(proxy.resource, id: 1, delete: nil) }

    before do
      allow(subject).to receive(:delete).and_return(nil)
      allow(proxy).to receive(:find).and_return(subject)
      proxy.delete(subject.id)
    end

    it { expect(subject).to have_received(:delete).with(no_args) }
  end
end
