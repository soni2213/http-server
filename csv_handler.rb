require 'csv'
class CsvHandler
  def self.input(data)
    CSV.open('contacted.csv', 'a+') do |csv|
      csv << data
    end
  end

  def self.output
    rows = []
    CSV.foreach('contacted.csv') do |row|
      rows << row
    end
    rows
  end
end
