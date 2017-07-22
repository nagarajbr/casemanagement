class AddColumnToCostCenterTable1 < ActiveRecord::Migration
  def change

  	add_column :cost_centers, :service_type, :integer

  end
end
