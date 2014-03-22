class AddLatitudeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :latitude, :string
  end
end
