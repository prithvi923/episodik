class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.integer :show_id
      t.string :genre
    end
  end
end
