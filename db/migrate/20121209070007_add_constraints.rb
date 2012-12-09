class AddConstraints < ActiveRecord::Migration
  def change
    remove_column :genres, :id
    remove_column :histories, :id
    execute "ALTER TABLE genres ADD PRIMARY KEY (show_id, genre);"
    execute "ALTER TABLE histories ADD PRIMARY KEY (user_id, show_id);"
    execute "ALTER TABLE histories ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE histories ADD FOREIGN KEY (show_id) REFERENCES tvshows(show_id)"
    execute "ALTER TABLE preferences ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE preferences ADD FOREIGN KEY (hot_sid) REFERENCES tvshows(show_id)"
    execute "ALTER TABLE preferences ADD FOREIGN KEY (not_sid) REFERENCES tvshows(show_id)"
    execute "ALTER TABLE genres MODIFY show_id int(11) NOT NULL;"
    execute "ALTER TABLE genres MODIFY genre varchar(255) NOT NULL;"
    execute "ALTER TABLE histories MODIFY show_id int(11) NOT NULL;"
    execute "ALTER TABLE histories MODIFY user_id int(11) NOT NULL;"
    execute "ALTER TABLE histories MODIFY rating int(11) NOT NULL;"
    execute "ALTER TABLE preferences MODIFY hot_sid int(11) NOT NULL;"
    execute "ALTER TABLE preferences MODIFY user_id int(11) NOT NULL;"
    execute "ALTER TABLE preferences MODIFY not_sid int(11) NOT NULL;"
    execute "ALTER TABLE tvshows MODIFY name varchar(255) NOT NULL;"
    execute "ALTER TABLE tvshows MODIFY year int(11) NOT NULL;"
    execute "ALTER TABLE tvshows MODIFY seasons int(11) NOT NULL;"
    execute "ALTER TABLE tvshows MODIFY episode_length int(11) NOT NULL;"
    execute "ALTER TABLE users MODIFY name varchar(255) NOT NULL;"
    execute "ALTER TABLE users MODIFY email varchar(255) NOT NULL;"
  end
end