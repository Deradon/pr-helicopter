
RSpec.shared_examples 'a Github::Proxy' do
  subject { described_class.new(secret: '', repo: 'org/repo') }

  describe '.resource' do
    subject { described_class.resource }
    it { is_expected.to_not be_nil }
    it { is_expected.to be_subclass_of(Github::Resource) }
  end

  context 'initialized without a secret' do
    it 'says it requires a secret' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end

  context 'initialized without a repo' do
    it 'works fine' do
      expect { described_class.new secret: '' }.not_to raise_error
    end
  end

  context 'initialized with secret and repo' do
    it 'works fine' do
      expect { described_class.new secret: '', repo: 'w/w' }.not_to raise_error
    end
  end

  describe 'repo attribute' do
    it { is_expected.to have_attributes(repo: 'org/repo') }
    it { is_expected.not_to respond_to(:repo=) }
  end

  describe 'secret attribute' do
    it { is_expected.to_not respond_to_public(:secret) }
    it { is_expected.not_to respond_to(:secret=) }
  end

  describe '.find(1)' do
    subject { described_class.new(secret: '').find(1) }
    it { is_expected.to be_a(described_class.resource) }
    it { is_expected.to have_attributes(id: 1) }
  end
end
