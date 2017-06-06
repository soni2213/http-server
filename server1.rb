require 'socket'
server1 = TCPServer.open('localhost', 1100)

  loop do
    socket = server1.accept
    response = "200 OK\n"
    socket.print "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n"
    socket.print response
    socket.close
  end                                                                                    
