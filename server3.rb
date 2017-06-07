require 'pry'
require 'socket'
server = TCPServer.open('localhost', 1200)
while (period = server.accept)
  request = period.gets
  filename = request.split(" ")[1]
  if filename == "/"
    file = "root.html"
  elsif File.extname(filename) == ".css"
    file = ".css"
  else
    file = filename.sub('/', '') + '.html'
  end
  begin
    if file == ".css"
      period.print "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n"
      period.print "serve the css\n"
    else
      displayfile = File.open(file, 'r')
      content = displayfile.read()
      period.print "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n"
      period.print content
    end
  rescue Errno::ENOENT
    message = "File not found\n"
    period.print "HTTP/1.1 404 Not Found\r\nContent-Type:text/html\r\n\r\n"
    period.print message
  end
  period.close
end


