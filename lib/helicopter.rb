
require 'webrick'

#
# The Helicopter wraps a webrick instance with 2 mounts:
#  /test => To test if its running
#  /     => Receives the web hooks from Github
#
# When an event was received, he will look for the files of that PR
# and send notifications if needed.
#
class Helicopter
  #
  # Webrick server instance
  attr_reader :server

  # Prepares the server but does not start them.
  # @param {repo} Github::Client instance
  def initialize(repo)
    @repo = repo
    @server = WEBrick::HTTPServer.new(Port: 80)

    setup
  end

  # Starts the server
  def start
    @server.start
  end

  # Shutdown the server
  def shutdown
    @server.shutdown
  end

  private

  # Mounts all routes of that server.
  def setup
    mount_test_route
    mount_root_route
  end

  # Mounts a simple test page to see if its running.
  def mount_test_route
    @server.mount_proc '/test' do |_, res|
      res.body = 'It works!'
    end
  end

  # Mounts the core handler that receives the hooks.
  def mount_root_route
    @server.mount_proc '/' do |req, res|
      res.body = 'Thanks!'

      if event?(req => :pull_request)
        id = extract_pull_id_from_payload(req.body)
        puts @repo.pulls[id].files.display # TODO...
      end
    end
  end

  # If the requests comes from that github event.
  # @param {entry} request:event
  # @return Boolean
  def event?(entry)
    request = entry.first.first
    event   = entry.first.last

    request.header['x-github-event'].include? event.to_s
  end

  # Returns the pull ID from the payload.
  # @param {payload} The received request body
  # @return String
  def extract_pull_id_from_payload(payload)
    url = payload.scan(/"pull_request":[^("url:")]"url": *"+([^"]+)/)
    url.flatten.first.split('/').last
  end
end
