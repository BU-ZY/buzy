class AddMugar < ActiveRecord::Migration
  def up
  	Place.create(id:1, name:'Mugar Library')
  end	
end
