require 'github/proxy'
require 'github/repository'

#
# Proxy for repository resources.
#  - Access repositories by name
#

module Github
  # Github::RepositoryProxy
  class RepositoryProxy < Proxy
    self.resource = Repository
  end
end
