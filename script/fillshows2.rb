require 'rubygems'
require 'nokogiri'
require 'rest-client'
require 'mysql'
require 'open-uri'
require 'mysql2'

show = "10 Items or Less".tr(" ", "_")

@WIKI_URL = "http://en.wikipedia.org/w/index.php?action=render&title=" + show + "&redirects"

WIKITV_URL = "http://en.wikipedia.org/w/index.php?action=render&title=" + show + "_(TV_series)&redirects"

puts WIKITV_URL

# @WIKI_PAGE = Nokogiri::HTML(RestClient.get(WIKITV_URL)) 

@WIKI_PAGE = Nokogiri::HTML(RestClient.get(WIKITV_URL, {:user_agent => "MyCoolTool/1.1 (http://example.com/MyCoolTool/; MyCoolTool@example.com)"}))

@network = @WIKI_PAGE.xpath('//tr//th[text()="Original channel"]/..//td//a/text()').text

@seasons = @WIKI_PAGE.xpath('//tr//th[text()="No. of seasons"]/..//td/text()').text

@year = @WIKI_PAGE.xpath('//tr//th[text()="Original run"]/..//td/text()').text

@ep_length = @WIKI_PAGE.xpath('//tr//th[text()="Running time"]/..//td/text()').text.split('-')[0]

puts @year
if false
    @year = 2012
else
    @year = @year.split(',').last.strip
end

puts @network
puts @seasons
puts @year
puts @ep_length