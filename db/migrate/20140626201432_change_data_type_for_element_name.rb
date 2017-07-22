class ChangeDataTypeForElementName < ActiveRecord::Migration
  def change
  	change_column :ruby_elements, :element_name, "varchar(100)"
  end
end
