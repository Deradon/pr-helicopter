
#
# Generic notification class.
# One notification might be sent to multiple channels.
#

class Helicopter
  # Helicopter::Notification
  class Notification
    # Initializes the notifcation.
    # @param {type} Type of the notification
    # @param {file} Path of the touched file
    # @param {pr} Link to the pull request
    def initialize(type: Helicopter.config.notification['type'], file:, pr:)
      @notification = build_notifiation(type, file, pr)
    end

    attr_reader :notification

    # Sends the email to the specified receivers.
    # @param {receivers} Single mail address or multiple receivers.
    def send_to(receivers)
      notification.send_to(receivers)
    end

    private

    # Builds the concrete notifcation specified by type.
    # @param {type} Type of the notification
    # @param {file} Path of the touched file
    # @param {pr} Link to the pull request
    # @return Instance of Notification::Base
    def build_notifiation(type, file, pr)
      cfg = Helicopter.config.notification

      subject_tpl = cfg['subject']
      body_tpl    = cfg['body']

      from    = cfg['from']
      subject = render_tpl(subject_tpl, file, pr)
      body    = render_tpl(body_tpl, file, pr)

      notificiation_class(type).new(
        from: from, subject: subject,
        body: body, credentials: credentials(type))
    end

    # Returns the credentials for that notification type.
    # @param {type} Type of the notification
    def credentials(type)
      Helicopter.config.credentials.fetch(type, {})
    end

    # Replaces the _file_ and _pr_ placeholders with the proper content.
    # @param {tpl} The tpl to render.
    # @param {file} Path of the touched file
    # @param {pr} Link to the pull request
    def render_tpl(tpl, file, pr)
      tpl.gsub('_file_', file).gsub('_pr_', pr)
    end

    # Returns the class specified by the type.
    # @param {type} Type of the notification
    def notificiation_class(type)
      require "helicopter/notification/#{type}"
      Helicopter::Notification.const_get(type.capitalize)
    end
  end
end
