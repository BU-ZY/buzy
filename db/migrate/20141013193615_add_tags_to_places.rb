class AddTagsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :tags, :string, array: true, default: '{}'
  end
end
