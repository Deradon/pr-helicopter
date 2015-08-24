
require 'github/request'
require 'uri'

#
# Base class for Github API resources.
#  - Provides basic functions to construct resource URI's
#  - Simply add proxies for associated resources
#
#  class Commit < Resource
#    endpoint '/commits'
#    proxy files: FileProxy
#  end
#
#  commit = Commit.find id: 123, repo: 'wimdu/wimdu'
#
#  commit.request_uri
#  => '/repos/wimdu/wimdu/commits/123'
#  commit.uri
#  => 'https://api.github.com/repos/wimdu/wimdu/commits/123'
#  commit.files['db/schema.rb']
#  => A single resource
#

module Github
  # @abstract Github::Resource
  class Resource
    # Finds the resource with given ID.
    # @param {id} ID to search for
    # @param {repo} Name of a github repo (:owner/:repo)
    # @param {secret} 40 digit access token
    # @return Github::WebHook
    def self.find(id, repo:, secret:)
      new(id: id, repo: repo, secret: secret)
    end

    # Returns the request URI for that resource.
    # @return String
    def self.request_uri(repo:, id: nil)
      File.join(*['/repos', repo, @endpoint, id].map(&:to_s)).chomp('/')
    end

    # Specified the endpoint for that resource
    # => endpoint '/pulls'
    def self.endpoint(uri) # rubocop:disable Metrics/TrivialAccessors
      @endpoint = uri
    end

    # Adds the specified proxy to this resource.
    # proxy(pulls: PullRequestProxy)
    def self.proxy(args)
      define_method(args.keys.first) do
        args.values.first.new(repo: repo, secret: secret)
      end
    end

    # Initializes the resource.
    # @param {id} Github Resource ID
    # @param {uri} Name of the repo
    # @param {secret} 40 digit access token
    def initialize(id:, repo:, secret:)
      @id     = id
      @repo   = repo
      @secret = secret
    end

    attr_reader :id, :repo, :secret

    # Returns the request URI for that resource.
    # @return String
    def request_uri
      self.class.request_uri(repo: repo, id: id)
    end

    # Returns the resource's URI.
    # @return String
    def uri
      URI.join('https://api.github.com', request_uri).to_s
    end

    # HTTP Net connection to communication with Github API.
    # @return {Github::Request}
    def request
      Github::Request.new(secret, uri)
    end

    protected :secret
  end
end
