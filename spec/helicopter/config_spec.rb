require 'fakefs/spec_helpers'
require 'helicopter/config'
require 'uri'
require 'yaml'

RSpec.describe Helicopter::Config do
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
    include FakeFS::SpecHelpers
    let(:file) { 'schema.rb' }
    let(:email) { 'me@test.de' }
    subject { described_class.new.receivers_for(file) }

    before do
      ENV['ENV'] = 'test'
      FileUtils.mkdir_p('config')

      File.open('config/receivers.yml', 'w') do |f|
        f.write({
          'groups' => { 'test' => { 'bi' => [email] } },
          'files' => { 'schema.rb' => 'bi' }
        }.to_yaml)
      end
    end

    it("#receivers_for('schema.rb') returns me@test.de") do
      is_expected.to eq([email])
    end
  end
end
