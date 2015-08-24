
require 'github/proxy'
require 'github/web_hook'

#
# Proxy for web hooks. Supports the following actions:
#  - Find & access web hooks by ID
#  - Add web hooks to repo
#  - Remove web hooks from repo
#

module Github
  # Github::WebHookProxy
  class WebHookProxy < Proxy
    self.resource = WebHook

    # Adds a web hook to the repo.
    # @param {callback} URL to which the payloads will be delivered
    # @param {events} Events the hook is triggered for
    # @return Github::WebHook instance
    def add(callback, events:[])
      resource.create(
        repo: repo,
        events: events,
        secret: secret,
        callback: callback)
    end

    # Deletes the web hook with the specified ID.
    # @param {id} ID of the web hook
    def delete(id)
      find(id).delete
    end
  end
end
