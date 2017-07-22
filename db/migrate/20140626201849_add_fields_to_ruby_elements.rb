class AddFieldsToRubyElements < ActiveRecord::Migration
  def change
    add_column :ruby_elements, :element_title, "varchar(50)"
    add_column :ruby_elements, :element_type, "char(2)"
    add_column :ruby_elements, :element_microhelp, :string
    add_column :ruby_elements, :element_help_page, :string
    add_column :ruby_elements, :created_by_user_id, :integer
    add_column :ruby_elements, :updated_by_user_id, :integer

  end
end