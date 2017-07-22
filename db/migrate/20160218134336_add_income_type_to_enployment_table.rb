class AddIncomeTypeToEnploymentTable < ActiveRecord::Migration
  def change
  	add_column :employments, :income_type, :integer
  end
end
