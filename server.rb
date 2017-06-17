require_relative 'csv_handler'
require 'socket'
require 'cgi'
class RequestHandler
  def initialize(ip, port)
    @server = TCPServer.open(ip, port)
  end

  def run
    while (@period = @server.accept)
      @method, @path = @period.gets.split(' ')
      if @method == 'POST'
        post_method(@period)
      else
        file = get_method(@path)
        begin
          begin_method(file)
        rescue Errno::ENOENT
          message = "File not found\n"
          error_response
          @period.print message
        end
      end
      @period.close
    end
  end

  def post_method(period)
    post_data(period)
    trimmed_data(@data)
    CsvHandler.input(@result)
    success_response
    period.print CsvHandler.output
  end

  def get_method(path)
    if path == '/'
      'index.html'
    elsif File.extname(path) == '.css' && path == '/main.css'
      'main.css'
    else
      path.sub('/', '') + '.html'
    end
  end

  def begin_method(file)
    content = file_reader(file)
    if File.extname(@path) == '.css' && @path == '/main.css'
      @period.print "HTTP/1.1 200 OK\r\nContent-Type:text/css\r\n\r\n"
    else
      success_response
    end
    @period.print content
  end

  def success_response
    @period.print "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n"
  end

  def error_response
    @period.print "HTTP/1.1 404 Not Found\r\nContent-Type:text/html\r\n\r\n"
  end

  def file_reader(file)
    displayfile = File.open(file, 'r')
    displayfile.read
  end

  def trimmed_data(data)
    @result = []
    data.split('&').each do |string|
      @result << CGI.unescape(string.gsub(/.*=/, ''))
    end
  end

  def post_data(period)
    headers = {}
    while line = period.gets.split(' ', 2)
      break if line[0] == ''
      headers[line[0].chop] = line[1].strip
    end
    @data = period.read(headers['Content-Length'].to_i)
  end
end

RequestHandler.new(ARGV[0], ARGV[1]).run
