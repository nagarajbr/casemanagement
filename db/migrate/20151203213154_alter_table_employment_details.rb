class AlterTableEmploymentDetails < ActiveRecord::Migration
	def up
	  	add_column :employment_details, :position_type_desc, :string
  	end
	def down
		remove_column :employment_details, :position_type_desc
	end
end
