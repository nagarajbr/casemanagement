class AlterEmployments2 < ActiveRecord::Migration
  def change
  	add_column :employments, :employer_id, :integer
  end
end
