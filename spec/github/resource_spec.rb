require 'github/resource'
require 'github/proxy'

RSpec.describe Github::Resource do
  let(:cls) do
    Class.new(described_class) do
      endpoint '/pulls'
      proxy commits: Github::Proxy
    end
  end

  let(:repo) { 'wimdu/wimdu' }
  let(:id) { 12 }
  let(:req_uri) { cls.request_uri(repo: repo, id: id) }

  context 'class' do
    let(:gen_uri) { cls.request_uri(repo: repo) }

    it 'is able to construct general request uri' do
      expect(gen_uri).to match('wimdu/wimdu/pulls')
    end

    it 'is able to construct request uri for instance' do
      expect(req_uri).to match('wimdu/wimdu/pulls/1')
    end

    it 'finds objources' do
      expect(cls.find(id, repo: repo, secret: '')).to be_a(cls)
    end
  end

  context 'instantiation' do
    it 'fails without an id' do
      expect { cls.new }.to raise_exception(ArgumentError)
    end

    it 'fails without an repo' do
      expect { cls.new(id) }.to raise_exception(ArgumentError)
    end

    it 'fails without an secret' do
      expect { cls.new(id, repo: repo) }.to raise_exception(ArgumentError)
    end
  end

  context 'instance' do
    let(:obj) { cls.new id: id, repo: repo, secret: '' }

    it 'has an id' do
      expect(obj.id).to eq(id)
    end

    it 'has an repo' do
      expect(obj.repo).to eq(repo)
    end

    it 'keeps its secret private' do
      expect(obj.public_methods.include? :secret).to be_falsy
    end

    it 'knows its request_uri' do
      expect(obj.request_uri).to match(req_uri)
    end

    it 'knows its uri' do
      expect(obj.uri).to eq("https://api.github.com#{req_uri}")
    end

    it 'got a proxy' do
      expect(obj.commits).to be_a(Github::Proxy)
    end
  end
end
