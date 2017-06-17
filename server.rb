require 'socket'
ip = ARGV[0]
port = ARGV[1]
server = TCPServer.open(ip, port)
while (period = server.accept)
  request = period.gets
  filename = request.split(" ")[1]
  if filename == "/"
    file = "index.html"
  elsif File.extname(filename) == ".css" && filename == "/main.css"
    file = "main.css"
  else
    file = filename.sub('/', '') + '.html'
  end
  begin
      displayfile = File.open(file, 'r')
      content = displayfile.read()
      if File.extname(filename) == '.css'
        period.print "HTTP/1.1 200 OK\r\nContent-Type:text/css\r\n\r\n"
      else
        period.print "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n"
      end
      period.print content
  rescue Errno::ENOENT
    message = "File not found\n"
    period.print "HTTP/1.1 404 Not Found\r\nContent-Type:text/html\r\n\r\n"
    period.print message
  end
  period.close
end


