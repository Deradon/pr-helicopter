
require 'webrick'

#
#
#
class Helicopter
  #
  # Webrick server instance
  attr_reader :server

  # Prepares the server but does not start them.
  # @param {repo} Github::Client instance
  def initialize(repo)
    @repo = repo
    @server = WEBrick::HTTPServer.new(Port: 3000)

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

  def mount_root_route
    @server.mount_proc '/' do |req, res|
      res.body = req.body
    end
  end
end
