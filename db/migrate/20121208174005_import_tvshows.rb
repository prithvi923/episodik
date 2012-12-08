class ImportTvshows < ActiveRecord::Migration
  def change
    File.open('./script/tvshows.csv', 'r').each do |line|
        show_id, name, year, seasons, episode_length = line.strip.split(",")
        show_id = show_id.gsub(/"/, '').to_i
        name = name.gsub(/"/, '')
        year = year.gsub(/"/, '').to_i
        seasons = seasons.gsub(/"/, '').to_i
        episode_length = episode_length.gsub(/"/, '').to_i
        t = Tvshow.new(:show_id => show_id, :name => name, :year => year.to_i, :seasons => seasons.to_i, :episode_length => episode_length.to_i)
        t.save
    end
  end
end