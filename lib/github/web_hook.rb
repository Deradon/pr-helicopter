
require 'github/resource'
require 'github/request'
require 'uri'

#
# Endpoint for web hook resources.
#  - Creates a new hook
#  - Deletes the hook
#

module Github
  # Github::WebHook
  class WebHook < Resource
    endpoint '/hooks'

    # Creates a new hook.
    # @param {repo} Name of a github repo (:owner/:repo)
    # @param {secret} 40-digit access token
    # @param {callback} URL to which the payloads will be delivered
    # @param {events} Events the hook is triggered for
    # @return Github::WebHook
    def self.create(repo:, secret:, callback:, events: [])
      body = generate_payload(events, callback)
      path = request_uri(repo: repo)
      req  = Github::Request.new(secret)
      res  = req.post(path, body)
      id   = res.body.scan(/\"id\":([^,]+)/).flatten.first

      fail res.body unless res.code == '201' && id

      new(id: id, repo: repo, secret: secret)
    end

    # Deletes this hook.
    def delete
      request.delete(request_uri)
    end

    # The payload used to create hooks.
    # @param {events} Events the hook is triggered for
    # @param {callback} URL to which the payloads will be delivered
    def self.generate_payload(events, callback)
      %({"name":"web","active":true,"events":#{events},"config":{"url":"#{callback}","content_type":"json"}}) # rubocop:disable Metrics/LineLength
    end

    class << self
      private :generate_payload
    end
  end
end
