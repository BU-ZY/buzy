class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.integer :score, :default => 50

      t.timestamps
    end
  end
end
