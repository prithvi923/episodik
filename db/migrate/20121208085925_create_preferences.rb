class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :user_id
      t.integer :hot_sid
      t.integer :not_sid
    end
    add_index :preferences, [:user_id, :hot_sid, :not_sid]
    execute "ALTER TABLE preferences ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE preferences ADD FOREIGN KEY (hot_sid) REFERENCES tvshows(show_id)"
    execute "ALTER TABLE preferences ADD FOREIGN KEY (not_sid) REFERENCES tvshows(show_id)"
  end
end