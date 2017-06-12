require 'pry'
require 'socket'
require 'csv'
require 'cgi'
require 'socket'
class RequestHandler
  def initialize(port, ip)
    @server = TCPServer.open(ip, port)
    run
  end

  def run
    while (@period = @server.accept)
      @method, @path = @period.gets.split
      if @method == "POST"
        post_method(@period)

      else
        get_method(@path)
        begin
          begin_method(@file)
          @period.print "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n"
          @period.print @text
        rescue Errno::ENOENT
          message = "File not found\n"
          @period.print "HTTP/1.1 404 Not Found\r\nContent-Type:text/html\r\n\r\n"
          @period.print message
        end
      end
      @period.close
    end
  end

  def post_method(period)
    headers = {}
    result = []
    while line = period.gets.split(' ', 2)
      break if line[0] == ""
      headers[line[0].chop] = line[1].strip
    end
    data = period.read(headers["Content-Length"].to_i)
    data.split('&').each do |string|
      result << CGI.unescape(string.gsub(/.*=/, ''))
    end
    CSV.open("contacted.csv", "a+") do |csv|
      csv << result
    end
    period.print "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n"
    CSV.foreach('contacted.csv') do |row|
      period.print row
    end
  end

  def get_method(path)
    if path == "/"
      @file = "root.html"
    elsif File.extname(path) == ".css"
      @file = ".css"
    else
      @file = path.sub('/', '') + '.html'
    end
  end

  def begin_method(file)
    @text = ""
    if @file == ".css"
      @text = "serve the css\n"
    else
      displayfile = File.open(@file, 'r')
      content = displayfile.read()
      @text << content
    end
  end
end


RequestHandler.new(1500, 'localhost')


