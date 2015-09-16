require 'fakefs/spec_helpers'
require 'helicopter/config'
require 'uri'

RSpec.describe Helicopter::Config do
  include FakeFS::SpecHelpers

  before do
    FakeFS::FileSystem.clone('spec/fixtures/config', 'config')
  end

  it { is_expected.to respond_to(:env, :receivers_for) }

  context 'checking config files' do
    it('github.yml exist') { expect(File).to exist('config/github.yml') }
    it('receivers.yml exist') { expect(File).to exist('config/receivers.yml') }
  end

  context 'when ENV is not set' do
    before { ENV.delete 'ENV' }
    subject { described_class.new.env }
    it { is_expected.to eq('development') }
  end

  context 'when ENV is set to "test"' do
    before { ENV['ENV'] = 'test' }
    subject { described_class.new.env }
    it { is_expected.to eq('test') }
  end

  describe '#repo' do
    subject { described_class.new.repo }
    it { is_expected.to_not be_nil }
    it('matches :org/:repo') { is_expected.to match(%r{^[a-z]+/[a-z]+$}) }
  end

  describe '#secret' do
    subject { described_class.new.secret }
    it { is_expected.to_not be_nil }
    it('is a 40 digit token') { is_expected.to match(/^[a-z0-9]{40}$/) }
  end

  describe '#hook' do
    subject { described_class.new.hook }
    it { is_expected.to_not be_nil }
    it('is valid URL') { expect(URI.parse(subject)).to be_a(URI::HTTP) }
  end

  context 'when me@test.de should get notified about changes in schema.rb' do
    before { ENV['ENV'] = 'test' }
    subject { described_class.new.receivers_for('schema.rb') }

    it("#receivers_for('schema.rb') returns me@test.de") do
      is_expected.to eq(['me@test.de'])
    end
  end
end
