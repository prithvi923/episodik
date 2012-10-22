require 'rubygems'
require 'nokogiri'
require 'rest-client'
require 'mysql'
require 'open-uri'
require 'mysql2'

client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "episodik_development")

client.query("SELECT * FROM tvshow LIMIT 1739, 50").each do |row|
    name = row['name']
    puts name
    show = URI::encode(name).downcase

    @TVDB_URL = "http://www.thetvdb.com/api/GetSeries.php?seriesname=" + show;

    @series_page = Nokogiri::XML(RestClient.get(@TVDB_URL))  

    @imdb_id = @series_page.css("IMDB_ID").text

    @IMDB_URL = "http://www.imdb.com/title/" + @imdb_id;

    begin
        @imdb_page = Nokogiri::HTML(RestClient.get(@IMDB_URL))
    rescue
        next
    else
        @infobar = @imdb_page.css('.infobar').text.split('-')

        ep_length = @infobar[1]
        if !ep_length then 
            next
        end
        ep_length = ep_length.gsub(/[^0-9]/, "")

        genre = @infobar[2]
        if !genre then 
            next
        end
        genre = genre.gsub(/[^a-zA-Z ]/, "")

        ys = @imdb_page.css('span.see-more')

        seasons = ys[0].text.split('|')[0].strip
        if !seasons then 
            next
        end
        seasons = seasons.gsub(/\s+/, "")

        year = ys[1].text.split('|')[0]
        if !year then 
            next
        end
        year = year.strip

        # WIKI_URL = "http://en.wikipedia.org/w/index.php?action=render&title=" + show + ""

        # puts WIKI_URL

        # @wiki_page = Nokogiri::HTML(RestClient.get(WIKI_URL))

        # @wiki_page.css('a').each { |link|
        #     link = link.attribute('href').value
        #     if (link.include? '(TV_series)')
        #         hrefs = link.split('/')
        #         WIKI_HREF = hrefs[hrefs.length-1]

        #         WIKI_URL = "http://en.wikipedia.org/w/index.php?action=render&title=" + WIKI_HREF + "&redirects"

        #         @wiki_page = Nokogiri::HTML(RestClient.get(WIKI_URL))

        #         # puts @wiki_page

        #         channel = @wiki_page.xpath('//tr//td[text()="Original channel"')
        #         puts channel

        #         break
        #     end
        # }

        puts ep_length
        puts genre
        puts seasons
        puts year.gsub(/\s+/, "")
        name = name.gsub(/'/, "''")
        @query = "UPDATE tvshow SET genre='#{genre}', episode_length='#{ep_length}', seasons='#{seasons}', year='#{year}' WHERE name='#{name}';"
        client.query(@query)
    end

end