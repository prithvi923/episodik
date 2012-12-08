class ImportGenres < ActiveRecord::Migration
  def change
    File.open('./script/genres.csv', 'r').each do |line|
        show_id, genre = line.strip.split(",")
        show_id = show_id.gsub(/"/, '').to_i
        genre = genre.gsub(/"/, '')
        g = Genre.new(:show_id => show_id, :genre => genre)
        g.save
    end
  end
end
