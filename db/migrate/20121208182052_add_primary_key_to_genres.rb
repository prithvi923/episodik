class AddPrimaryKeyToGenres < ActiveRecord::Migration
  def change
    add_index(:genres, [:show_id, :genre], :unique => true)
  end
end
