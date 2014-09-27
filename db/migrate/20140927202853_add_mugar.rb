class AddMugar < ActiveRecord::Migration
  def up
  	Place.create(name:'Mugar Library')
  end	
end
