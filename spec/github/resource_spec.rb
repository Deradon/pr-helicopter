require 'github/resource'
require 'github/proxy'

RSpec.describe Github::Resource do
  let(:res_cls) do
    Class.new(described_class) do
      endpoint '/pulls'
      proxy commits: Github::Proxy
    end
  end

  let(:repo) { 'wimdu/wimdu' }
  let(:id) { 12 }
  let(:req_uri) { res_cls.request_uri(repo: repo, id: id) }

  context 'class' do
    let(:gen_uri) { res_cls.request_uri(repo: repo) }

    it 'is able to construct general request uri' do
      expect(gen_uri).to match('wimdu/wimdu/pulls')
    end

    it 'is able to construct request uri for instance' do
      expect(req_uri).to match('wimdu/wimdu/pulls/1')
    end

    it 'finds resources' do
      expect(res_cls.find(id, repo: repo, secret: '')).to be_a(res_cls)
    end
  end

  context 'instantiation' do
    it 'fails without an id' do
      expect { res_cls.new }.to raise_exception(ArgumentError)
    end

    it 'fails without an repo' do
      expect { res_cls.new(id) }.to raise_exception(ArgumentError)
    end

    it 'fails without an secret' do
      expect { res_cls.new(id, repo: repo) }.to raise_exception(ArgumentError)
    end
  end

  context 'instance' do
    let(:res) { res_cls.new id: id, repo: repo, secret: '' }

    it 'has an id' do
      expect(res.id).to eq(id)
    end

    it 'has an repo' do
      expect(res.repo).to eq(repo)
    end

    it 'keeps its secret private' do
      expect(res.public_methods.include? :secret).to be_falsy
    end

    it 'knows its request_uri' do
      expect(res.request_uri).to match(req_uri)
    end

    it 'knows its uri' do
      expect(res.uri).to eq("https://api.github.com#{req_uri}")
    end

    it 'got a proxy' do
      expect(res.commits).to be_a(Github::Proxy)
    end
  end
end
