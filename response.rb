require_relative 'db_handler'
class Response
  def response_method(socket, period, file)
    status_code, type, body = response(socket, period, file)
    headers = ['HTTP/1.1 ' + status_code,
               'Content-Type: '+ type,
               'Connection: close']
    socket.puts(headers)
    socket.puts("\r\n")
    socket.puts(body)
    socket.close
  end

  def response(socket, period, file)
    status_code = ['200 OK', '404 Not Found']
    method = period.split(' ')[0]
    if method == 'POST'
      data = Request.headers(socket)
      DbHandler.insert_values(data)
      body = DbHandler.output_db
      return status_code[0], 'text/plain', body
    else
      displayfile = File.open(file, 'r')
      body = displayfile.read
      if File.exist?(file) && !File.directory?(file)
        return status_code[0], content_type(file), body
      else
        return status_code[1], 'text/plain', 'File not found'
      end 
    end
  end

  def content_type(file)
    ext = File.extname(file)
    ['text', ext.gsub('.', '')].join('/')
  end
end
































