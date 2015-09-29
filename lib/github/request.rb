require 'net/http'
require 'openssl'
require 'uri'

#
# Allows high level usage of Github Api calls.
# Handles authorization and other stuff that's required
# to works with Github API.
#

module Github
  # Github::Request
  class Request
    # Creates a generic GitHub Api request.
    # @param {secret} 40-digit access token
    # @param {uri} Github Api URI
    def initialize(secret, uri = 'https://api.github.com')
      @secret = secret
      @uri    = URI.parse(uri)
    end

    # Makes an async GET request.
    # @param {path} Resource request URI
    # @param {payload} Additional body payload
    # @return Net response
    def get(path, payload = nil)
      get_response(Net::HTTP::Get.new(path), payload)
    end

    # Makes an async GET request.
    # @param {path} Resource request URI
    # @param {payload} Additional body payload
    # @return Net response
    def post(path, payload = nil)
      get_response(Net::HTTP::Post.new(path), payload)
    end

    # Makes an async DELETE request.
    # @param {path} Resource request URI
    # @param {payload} Additional body payload
    # @return Net response
    def delete(path, payload = nil)
      get_response(Net::HTTP::Delete.new(path), payload)
    end

    private

    # Executes the request and returns its response.
    # @param {request} Net request instance
    # @param {payload} Additional body payload
    # @return Net response
    def get_response(request, payload = nil)
      add_headers_and_payload(request, payload)
      http.request(request)
    end

    # Handles HTTP requests.
    def http
      @http ||= Net::HTTP.new(@uri.host, @uri.port).tap do |http|
        http.use_ssl     = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    # Helper to configure GET or POST requests.
    # @param {request} Net request to configure
    # @param {payload} Additional body payload
    # @return request
    def add_headers_and_payload(request, payload = nil)
      request.add_field('Authorization', "token #{@secret}")
      request.add_field('Content-Type', 'application/json')
      request.body = payload if payload
      request
    end
  end
end
