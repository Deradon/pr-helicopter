require 'net/http'
require 'openssl'
require 'uri'
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
        Array(to).each do |recipient|
          params = credentials.merge(
            to: recipient, from: from, subject: subject, html: body)

          Net::HTTP.post_form(uri, params)
        end
      end

      private

      # Returns the parsed sendgrid URI.
      def uri
        URI.parse('https://api.sendgrid.com/api/mail.send.json')
      end
    end
  end
end
