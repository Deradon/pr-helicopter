
RSpec.shared_examples 'a Github::Resource' do
  let(:repo) { 'wimdu/wimdu' }

  describe '.endpoint' do
    subject { described_class.endpoint }
    it { is_expected.to_not be_nil }
    it { is_expected.to match(%r{^/?[^/]+$}) }
  end

  describe '.request_uri' do
    let(:endpoint) { File.join('', described_class.endpoint) }

    context 'with ID' do
      subject { described_class.request_uri(repo: repo, id: 1) }
      it { is_expected.to match("#{repo}#{endpoint}/1") }
    end

    context 'without ID' do
      subject { described_class.request_uri(repo: repo) }
      it { is_expected.to match("#{repo}#{endpoint}") }
    end
  end

  describe '.find(1, repo:)' do
    subject { described_class.find(1, repo: repo, secret: '') }
    it { is_expected.to be_a(described_class) }
    it { is_expected.to have_attributes(id: 1, repo: repo) }
  end

  context 'initialized without an ID' do
    it 'says it requires an ID' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end

  context 'initialized without a secret' do
    it 'says it requires a secret' do
      expect { described_class.new 1, repo: '' }.to raise_error(ArgumentError)
    end
  end

  context 'initialized without a repo' do
    it 'says it requires a repo' do
      expect { described_class.new 1, secret: '' }.to raise_error(ArgumentError)
    end
  end

  subject { described_class.new(id: 1, repo: repo, secret: '') }

  it { is_expected.not_to respond_to(:id=, :repo=, :secret=) }
  it { is_expected.to_not respond_to_public(:secret) }

  describe "#{described_class}.new id: 1, repo: 'wimdu/wimdu', secret: '...'" do
    let(:obj) { described_class.new(id: 1, repo: repo, secret: '') }
    let(:req_uri) { "/repos/#{repo}#{described_class.endpoint}/1" }
    subject { obj }
    it { is_expected.to have_attributes(id: 1, repo: repo) }

    describe '.request_uri' do
      subject { obj.request_uri }
      it { is_expected.to eq(req_uri) }
    end

    describe '.uri' do
      subject { obj.uri }
      it { is_expected.to eq("https://api.github.com#{req_uri}") }
    end
  end
end
