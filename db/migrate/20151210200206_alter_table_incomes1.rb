class AlterTableIncomes1 < ActiveRecord::Migration
  def up
  	add_column :incomes, :position_type, :string
  	add_column :incomes, :employer_id, :integer
  	remove_column :income_details, :employment_detail_id
  end
  def down
  	remove_column :incomes, :position_type
  	remove_column :incomes, :employer_id
  	add_column :income_details, :employment_detail_id, :integer
  end
end
