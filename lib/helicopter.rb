
require 'webrick'
require 'helicopter/config'

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
  # @param {on_pull} Proc to execute when a pull hook was received.
  def initialize(on_pull:, port: 3000)
    @server = WEBrick::HTTPServer.new(Port: port)
    @on_pull_proc = on_pull
    setup
  end

  # Returns an instance of Helicopter::Config
  def self.config
    @cfg ||= Config.new
  end

  # Starts the server.
  def start
    @server.start
  end

  # Shutdowns the server.
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

      grep_files_and_notify(req) if event? req => :pull_request
    end
  end

  # Greps the list of the pull request and sends out notifications.
  # @param {request} The received Net request with the payload.
  def grep_files_and_notify(req)
    url = extract_url_from_payload(req.body)
    id  = url.flatten.first.split('/').last
    @on_pull_proc.call(id, url)
  end

  # If the requests comes from that github event.
  # @param {entry} request:event
  # @return Boolean
  def event?(entry)
    request = entry.first.first
    event   = entry.first.last

    request.header['x-github-event'].include? event.to_s
  end

  # Returns the pull URL from the payload.
  # @param {payload} The received request body
  # @return String
  def extract_url_from_payload(payload)
    payload.scan(/"pull_request":[^("url:")]"url": *"+([^"]+)/)
  end
end
