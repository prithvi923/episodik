class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations, {:id => false} do |t|
      t.integer :user_id
      t.integer :show_id
    end
    execute "ALTER TABLE recommendations ADD PRIMARY KEY (user_id, show_id);"
    execute "ALTER TABLE recommendations ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE recommendations ADD FOREIGN KEY (show_id) REFERENCES tvshows(show_id)"
    execute "ALTER TABLE recommendations MODIFY user_id int(11) NOT NULL;"
    execute "ALTER TABLE recommendations MODIFY show_id int(11) NOT NULL;"
  end
end
