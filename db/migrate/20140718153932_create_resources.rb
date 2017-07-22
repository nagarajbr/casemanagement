class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :resource_type, null:false
      t.decimal :net_value, precision: 8, scale: 2
      t.string  :description, limit:50
      t.date :date_value_determined
      t.date :date_assert_acquired
      t.date :date_assert_disposed
      t.string :verified, limit: 1
      t.string :account_number, limit: 12
      t.decimal :use_code, precision: 4, scale: 1
      t.integer :number_of_owners
      t.string :license_number, limit: 10
      t.string :make, limit: 20
      t.string :model, limit: 20
      t.string :year, limit: 4
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
