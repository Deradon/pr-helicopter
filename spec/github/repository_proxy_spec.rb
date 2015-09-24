
RSpec.describe Github::RepositoryProxy do
  it_behaves_like 'a Github::Proxy'

  describe '.resource' do
    subject { described_class.resource }
    it { is_expected.to be_subclass_of(Github::Repository) }
  end
end
