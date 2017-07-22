class AddColumnToAddressFederalHousingFlag < ActiveRecord::Migration
  def change
  	add_column :addresses, :federal_housing_flag, "char(1)"
  end
end
