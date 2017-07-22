class AlterRubyElementReltns5 < ActiveRecord::Migration
  def change
  		add_column :ruby_element_reltns, :child_order, "integer"
  end
end
