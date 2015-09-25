
RSpec.describe Helicopter::Notification do
  subject { described_class.new pr: '', file: '' }
  it { is_expected.to respond_to(:send_to, :notification) }

  describe '#send_to' do
    let(:katzer) { 'katzer.wimdu.com' }

    before do
      allow(subject.notification).to receive(:send_to).and_return(nil)
      subject.send_to katzer
    end

    it('delegates to notification') do
      expect(subject.notification).to have_received(:send_to).with(katzer)
    end
  end

  context 'when type is email' do
    let(:wrapper) { described_class.new type: 'email', pr: '', file: '' }

    describe '#notification' do
      subject { wrapper.notification }
      it { is_expected.to be_a(Helicopter::Notification::Email) }
    end
  end
end
