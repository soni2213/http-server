require 'socket'
server = TCPServer.open('localhost', 1300)
while (period = server.accept)
  request = period.gets
  filename = request.split(" ")[1]
  if filename == "/"
    filename = "test.html"
  end
  begin
    displayfile = File.open(filename, 'r')
    content = displayfile.read()
    period.print "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n"
    period.print content
  rescue Errno::ENOENT
    message = "File not found\n"
    period.print "HTTP/1.1 404 Not Found\r\nContent-Type:text/html\r\n\r\n"
    period.print message
  end
  period.close
end


