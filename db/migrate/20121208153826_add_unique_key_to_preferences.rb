class AddUniqueKeyToPreferences < ActiveRecord::Migration
  def change
    add_index :preferences, [:hot_sid, :not_sid, :user_id], :unique => true
  end
end
