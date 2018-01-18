require 'pg'
require 'yaml'
require 'cgi'
class DbHandler
  def self.connection
    parsed = begin
      configurations = YAML.load(File.open('./public/db_config.yml'))
    rescue ArgumentError => e
      puts "Could not parse YAML: #{e.message}"
    end
    PG.connect :dbname => configurations['dbname'], :host => configurations['host'], :port => configurations['port'], :user => configurations['user'], :password => configurations['password']
  end

  def self.insert_values(data)
    result = []
    data.split('&').each do |string|
      result << CGI.unescape(string.gsub(/.*=/, ''))
    end 

    connection.exec "INSERT INTO Contact VALUES(DEFAULT, '#{result[0]}', '#{result[1]}', '#{result[2]}')"
  end

  def self.output_db
    rows = []
    begin
      rs = connection.exec "SELECT * FROM Contact"
      rs.each do |row|
        "%s %s %s %s" % [ row['id'], row['name'], row['email'], row['comment'] ]
        rows << row
      end
      rows
    rescue PG::Error => e
      puts e.message 
    ensure
      rs.clear if rs
    end
  end
end
