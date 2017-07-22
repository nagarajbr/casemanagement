class AddColumnsToClientCharacteristics < ActiveRecord::Migration
  def up
  	add_column :client_characteristics, :start_date , :date, null:false
  	add_column :client_characteristics, :end_date , :date
  end
end
