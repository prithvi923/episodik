class CreateTvshows < ActiveRecord::Migration
    def change
        create_table(:tvshows, :primary_key => 'show_id') do |t|
            t.integer :show_id
            t.string :name
            t.integer :year
            t.integer :seasons
            t.integer :episode_length

            t.timestamps
        end
    end
end
