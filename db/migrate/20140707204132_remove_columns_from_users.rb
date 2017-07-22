class RemoveColumnsFromUsers < ActiveRecord::Migration
  def up
  	 remove_column :users, :phone_area_code
	 remove_column :users, :phone_prefix
	 remove_column :users, :phone_ext
	 add_column :users, :phone_number, "varchar(10)"
  end

  def down
  	# rollback to what it was
  	add_column :users, :phone_area_code, :string
	add_column :users, :phone_prefix, :string
	add_column :users, :phone_ext, :string
  end
end
