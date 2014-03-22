class AddLongitudeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :longitude, :string
  end
end
