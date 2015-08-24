
#
# Base class for Github resource proxies.
#  - Find & access resources by ID
#

module Github
  # @abstract Github::Proxy
  class Proxy
    #
    class << self
      attr_accessor :resource
    end

    # Initializes the proxy.
    # @param {secret} 40 digit access token
    # @param {repo} Name of a github repo (:owner/:repo)
    def initialize(secret:, repo: nil)
      @repo   = repo
      @secret = secret
    end

    attr_reader :repo, :secret
    protected :secret

    # Returns the resource with the specified ID.
    # @param {id} ID of the resource
    # @return <? extends Github::Resource>
    def find(id)
      self.class.resource.find(id, repo: repo || id, secret: secret)
    end

    alias_method :[], :find

    # Returns the managed resource class.
    # @return Class
    def resource
      self.class.resource
    end
  end
end
