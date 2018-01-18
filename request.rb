require 'uri'
class Request
  def self.request_method(period)
    request_uri = period.split(' ')[1]
    path = URI.unescape(URI(request_uri).path)
    if path == '/'
      return 'index'
    else 
      path.gsub('/', '')
    end
  end

  def self.headers(socket)
    headers = {}
      while line = socket.gets.split(' ', 2)
        break if line[0] == ''
        headers[line[0].chop] = line[1].strip
      end 
    socket.read(headers['Content-Length'].to_i)
  end 
end



