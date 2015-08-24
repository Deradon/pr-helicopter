
require 'github/proxy'
require 'github/pull_request'

#
# Proxy for pull request resources.
#  - Find & access pull requests by ID
#

module Github
  # Github::PullRequestProxy
  class PullRequestProxy < Proxy
    self.resource = PullRequest
  end
end
