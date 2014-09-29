class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, :null => false
      t.integer :score
      t.timestamps
    end
  end
end
