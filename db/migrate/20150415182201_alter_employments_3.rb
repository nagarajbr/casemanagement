class AlterEmployments3 < ActiveRecord::Migration
  def change
  	change_column :employments, :employer_name, :string, limit: 35, null:true
  	change_column :employments, :employer_id, :integer, null:false
  end
end
