require 'rubygems'
require 'nokogiri'
require 'rest-client'
require 'mysql'


my = Mysql::new("localhost", "root", "", "episodik_development")
PAGE_URL = "http://www.free-tv-video-online.me/internet/";

page = Nokogiri::HTML(RestClient.get(PAGE_URL))   
puts page.class   # => Nokogiri::HTML::Document
shows = page.css(".mnlcategorylist a")
my.query("TRUNCATE TABLE tvshow")

shows.each do |show| 
    # puts show.text
    query = 'INSERT INTO tvshow (name) VALUES ("' + show.text + '");'
    puts query
    my.query(query)
end

res = my.query("select * from tvshow")
res.each do |row|
  puts row
end