class CreateAddColumnToUsers < ActiveRecord::Migration
   def up
  	add_column :users, :reports_to, :integer
   end
end
