desc "Import shows." 
  task :import_shows => :environment do
    my_sql = "SELECT * FROM tvshow;"
    ActiveRecord::Base.connection.execute(my_sql).each do |row|
      show_id, name, year, seasons, episode_length = row
      t = Tvshow.new(:show_id => show_id, :name => name, :year => year, :seasons => seasons, :episode_length => episode_length)
      t.save
    end
  end