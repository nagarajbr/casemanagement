class AlterClientResource1 < ActiveRecord::Migration
  def change
  	add_column :client_resources, :usage_percentage, :decimal,precision: 5, scale: 2
  end
end
