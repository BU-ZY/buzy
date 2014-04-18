class AddScoreToPlaces < ActiveRecord::Migration
  def change
  	add_column :places, :score, :integer
  	add_index :places, :score
  end
end
