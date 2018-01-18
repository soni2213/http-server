#!usr/bin/ruby
require 'pg'

begin
  con = PG.connect :dbname => 'home_db_development', :host => 'localhost', :port => '5432', :user => 'sonisahu', :password => 'soni'

  con.exec "DROP TABLE IF EXISTS Contact"
  con.exec "CREATE TABLE Contact(Id SERIAL PRIMARY KEY, Name VARCHAR(30), Email VARCHAR(20), Comment TEXT)"
 
rescue PG::Error => e
  puts e.message

ensure
  con.close if con
end



