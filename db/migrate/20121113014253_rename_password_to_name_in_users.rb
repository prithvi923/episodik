class RenamePasswordToNameInUsers < ActiveRecord::Migration
  def up
    rename_column :users, :password, :name
  end

  def down
  end
end
