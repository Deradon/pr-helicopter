require 'github/web_hook'

RSpec.describe Github::WebHook do
  it_behaves_like 'a Github::Resource'

  describe '.endpoint' do
    subject { described_class.endpoint }
    it { is_expected.to match(%r{/?hooks$}) }
  end

  let(:obj) { described_class.new(id: 1, repo: 'wimdu/wimdu', secret: '') }

  describe '.delete' do
    before do
      @stub = stub_request(:delete, obj.uri)
      obj.delete
    end

    it('should make a DELETE request') { expect(@stub).to have_been_requested }
  end
end
