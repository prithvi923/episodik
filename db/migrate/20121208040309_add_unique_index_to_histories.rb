class AddUniqueIndexToHistories < ActiveRecord::Migration
  def change
    add_index :histories, [:show_id, :user_id], :unique => true
  end
end
