class AddColumnsTepcTemp < ActiveRecord::Migration
  def up
  	add_column :tepc_temp, :first_name, :string
  	add_column :tepc_temp, :last_name, :string
  	add_column :tepc_temp, :middle_name, :string
  	add_column :tepc_temp, :name_suffix, :string
  end
end
