require 'rubygems'
require 'mysql'
require 'mysql2'

client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "episodik_development")

client.query("SELECT * FROM genres").each do |row|
    show_id = row['show_id']
    genres = row['genre'].split(' ')
    if genres.size == 1 then
        next
    end
    genres.each do |genre|
        @query = "INSERT INTO genres VALUES (#{show_id}, '#{genre}')"
        client.query(@query)
    end
    @query = "DELETE FROM genres WHERE show_id='#{show_id}' AND genre='#{row['genre']}'"
    client.query(@query)
end