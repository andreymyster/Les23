require 'SQLite3'

db = SQLite3::Database.new 'barbershop.db'

db.results_as_hash = true

# @table=""
# db.execute 'SELECT * from Users' do |hh|
#   @table += "<tr><td>"
#   @table += hh.values.join('</td><td>')
#   @table += "</td></tr>"
# end

puts db.execute 'SELECT * from Users'

# puts @table
