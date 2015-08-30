require 'github/pull_request'

RSpec.describe Github::PullRequest do
  it_behaves_like 'a Github::Resource'

  describe '.endpoint' do
    subject { described_class.endpoint }
    it { is_expected.to match(%r{/pulls$}) }
  end

  subject { described_class.new(id: 1, repo: 'repo', secret: 'abc') }

  describe '.files' do
    before do
      stub_request(:get, "#{subject.uri}/files")
        .to_return(body: '[{"filename":"file1.txt"}]', status: status)
    end

    context 'when Github responds with 200' do
      let(:status) { 200 }
      it('returns list of files') { expect(subject.files).to eq(['file1.txt']) }
    end

    context 'when Github responds with others than 200' do
      let(:status) { 401 }
      it('fails') { expect { subject.files } .to raise_error(RuntimeError) }
    end
  end

  describe '.file_included?' do
    before { allow(subject).to receive(:files).and_return([:file1, :file2]) }

    context 'with a file that is in the list' do
      it('returns true') { expect(subject.file_included?(:file1)).to be_truthy }
    end

    context 'with a file that is not in the list' do
      it('returns false') { expect(subject.file_included?(:file3)).to be_falsy }
    end
  end
end
