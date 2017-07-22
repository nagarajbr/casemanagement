class AlterHouseholdsAddStateField < ActiveRecord::Migration
  def change

  	add_column :households, :state, :integer
  end
end
