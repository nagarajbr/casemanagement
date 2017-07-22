class AddModifyAddressTable < ActiveRecord::Migration
  def up
  	add_column :addresses, :address_notes, :text
  	change_column :addresses, :address_type, :integer, null:false
  	change_column :addresses, :address_line1, :string, limit: 50, null:false
  	change_column :addresses, :city, :string, limit: 50, null:false
  	change_column :addresses, :state, :integer, null:false
  	change_column :addresses, :zip, :string, limit: 5, null:false
  end
end
