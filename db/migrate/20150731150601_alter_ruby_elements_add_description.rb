class AlterRubyElementsAddDescription < ActiveRecord::Migration
  def change
  	add_column :ruby_elements, :description, :string
  end
end
