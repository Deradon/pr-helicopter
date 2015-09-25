require 'helicopter/notification/base'

#
# Email notification using sendgrid.
#

class Helicopter
  # Helicopter::Notification
  class Notification
    # Helicopter::Notification::Email
    class Email < Base
      # Sends the email to the specified receivers.
      # @param {to} Single mail address or multiple receivers.
      def send_to(to)
        puts(from: from, to: to, subject: subject, body: body)
        # TODO..
      end
    end
  end
end
