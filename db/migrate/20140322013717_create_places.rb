class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, :null => false
      t.integer :score, :null => false, :default => 50
      t.timestamps
    end
  end
end
