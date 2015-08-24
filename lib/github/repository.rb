
require 'github/resource'
require 'github/web_hook_proxy'
require 'github/pull_request_proxy'

#
# Endpoint for repositories.
#  - Access the web hooks
#  - Access the pull requests
#

module Github
  # Github::Repository
  class Repository < Resource
    endpoint '/repos'
    # Gives access to the repo's web hooks
    proxy web_hooks: WebHookProxy
    # Gives access to the repo's pull requests
    proxy pulls: PullRequestProxy
  end
end
