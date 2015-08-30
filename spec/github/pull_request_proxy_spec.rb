require 'github/pull_request_proxy'

RSpec.describe Github::PullRequestProxy do
  it_behaves_like 'a Github::Proxy'

  describe '.resource' do
    subject { described_class.resource }
    it { is_expected.to be_subclass_of(Github::PullRequest) }
  end
end
