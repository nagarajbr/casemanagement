class CreateClientIncomes < ActiveRecord::Migration
  def change
    create_table :client_incomes do |t|
      t.references :client
      t.references :income
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
