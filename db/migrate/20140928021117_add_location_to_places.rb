class AddLocationToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :location, :string, default: ""
  end
end
