class AlterRubyElements2 < ActiveRecord::Migration
  def change
  		 change_column :ruby_elements, :element_type, 'integer USING CAST(element_type AS integer)'
  end
end
