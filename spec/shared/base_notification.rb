
RSpec.shared_examples 'a Helicopter::Notification::Base' do
  subject { described_class.new from: '', subject: '', body: '' }
  it { is_expected.to respond_to(:from, :subject, :body, :credentials) }
  it { is_expected.to respond_to(:send_to).with(1).argument }
end
