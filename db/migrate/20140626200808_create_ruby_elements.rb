class CreateRubyElements < ActiveRecord::Migration
  def change
    create_table :ruby_elements do |t|
      t.string :element_name

      t.timestamps
    end
  end
end
