class AddColumnToCostCenterTable < ActiveRecord::Migration
  def change
  	add_column :cost_centers, :threshold_amount, :decimal, precision: 8, scale: 2
  end
end
