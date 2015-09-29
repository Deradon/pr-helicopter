
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
      # @param {credentials} Required credentials for authentification
      def initialize(from:, subject:, body:, credentials: nil)
        @from        = from
        @subject     = subject
        @body        = body
        @credentials = credentials
      end

      attr_reader :from, :subject, :body, :credentials

      # Sends the email to the specified receivers.
      # @param {to} Single mail address or multiple receivers.
      def send_to(_)
        fail(NotImplementedError)
      end
    end
  end
end
