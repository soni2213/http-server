require_relative 'request'
require_relative 'response'
require_relative 'routes'
require 'socket'

class RequestHandler
  def initialize(ip, port)
    @server = TCPServer.open(ip, port)
  end

  def run
    while (socket = @server.accept)
      period = socket.gets
      request_line = Request.request_method(period)
      file = Routes.requested_file(request_line)
      Response.new.response_method(socket, period, file)
    end
  end
end

  RequestHandler.new(ARGV[0], ARGV[1]).run


