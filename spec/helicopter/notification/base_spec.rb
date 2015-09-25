
RSpec.describe Helicopter::Notification::Base do
  it_behaves_like 'a Helicopter::Notification::Base'

  subject { described_class.new from: '', subject: '', body: '' }

  it('does not implement any logic') do
    expect { subject.send_to([]) }.to raise_error(NotImplementedError)
  end
end
