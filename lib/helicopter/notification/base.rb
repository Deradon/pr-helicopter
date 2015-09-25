
#
# Base class for various notifications like mail or flowdock.
#

class Helicopter
  # Helicopter::Notification
  class Notification
    # Helicopter::Notification::Base
    class Base
      # Initializes the e-mail.
      # @param {from} The from email adress
      # @param {subject} The subject of the email
      # @param {body} The body of the email
      def initialize(from:, subject:, body:)
        @from    = from
        @subject = subject
        @body    = body
      end

      attr_reader :from, :subject, :body

      # Sends the email to the specified receivers.
      # @param {to} Single mail address or multiple receivers.
      def send_to(to)
        puts(from: from, to: to, subject: subject, body: body)
        fail(NotImplementedError)
      end
    end
  end
end
