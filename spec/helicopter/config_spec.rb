require 'uri'

RSpec.describe Helicopter::Config do
  it { is_expected.to respond_to(:env, :receivers_for, :to_h) }

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

  context 'when me@test.de should get notified about changes in schema.rb' do
    before { ENV['ENV'] = 'test' }
    subject { described_class.new.receivers_for('db/schema.rb') }

    it("#receivers_for('db/schema.rb') returns me@test.de") do
      is_expected.to eq(['me@test.de'])
    end
  end

  describe 'inspect' do
    let(:cfg) { described_class.new }
    subject { cfg.inspect }
    it { is_expected.to eq(cfg.to_h.inspect)}
  end
end
