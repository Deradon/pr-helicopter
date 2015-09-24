
RSpec.describe Github::WebHook do
  it_behaves_like 'a Github::Resource'

  describe '.endpoint' do
    subject { described_class.endpoint }
    it { is_expected.to match(%r{/?hooks$}) }
  end

  let(:obj) { described_class.new(id: 1, repo: 'w/w', secret: '') }

  context 'when deleting the resource' do
    before do
      @stub = stub_request(:delete, obj.uri)
      obj.delete
    end

    it('should make a DELETE request') { expect(@stub).to have_been_requested }
  end

  context 'when creating a resource' do
    before do
      uri = obj.uri.chomp('/1')
      @stub = stub_request(:post, uri).to_return(status: 201, body: '"id":11')
      @res = described_class.create(repo: 'w/w', secret: '', callback: 'uri')
    end

    it('should make a POST request') { expect(@stub).to have_been_requested }
    it { expect(@res).to be_a(described_class) }
  end
end
