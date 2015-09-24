
RSpec.describe Github::Repository do
  it_behaves_like 'a Github::Resource'

  describe '.endpoint' do
    subject { described_class.endpoint }
    it { is_expected.to match(%r{/?repos$}) }
  end

  let(:obj) { described_class.new(id: 1, repo: '', secret: '') }

  describe 'proxies' do
    subject { obj }
    it { is_expected.to respond_to(:web_hooks, :pulls) }
  end

  describe '.web_hooks' do
    subject { obj.web_hooks }
    it { is_expected.to be_a(Github::WebHookProxy) }
  end

  describe '.pulls' do
    subject { obj.pulls }
    it { is_expected.to be_a(Github::PullRequestProxy) }
  end
end
