class AlterTableRubyElements < ActiveRecord::Migration
  def change
  	change_column :ruby_elements, :element_name,:string,limit: 255
  end
end
