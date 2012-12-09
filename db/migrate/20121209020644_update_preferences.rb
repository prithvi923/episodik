class UpdatePreferences < ActiveRecord::Migration
  def change
    remove_column :preferences, :id
  end
end
