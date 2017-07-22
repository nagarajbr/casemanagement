class AddColumnsToEmployersTable1 < ActiveRecord::Migration
  def change
  	add_column :employers, :notes, :text
    add_column :employers, :email_address, "varchar(50)"
  end
end
