require 'github/repository_proxy'

#
# Client for Github API v3.
#  - Add/Remove web hooks to a repository
#  - Get details for a pull request
#  - Get list of files of an pull request
#

module Github
  # Github::Client
  class Client
    # Initializes the client.
    # @param {secret} 40 digit access token
    def initialize(secret:)
      @secret = secret
    end

    # Gives access to all proxy associated to the secret.
    # @return Github::RepositoryProxy
    def repos
      Github::RepositoryProxy.new(secret: @secret)
    end
  end
end
