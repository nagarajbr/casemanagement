class CreateAccountNumbers < ActiveRecord::Migration
  def change
    create_table :account_numbers do |t|
      t.integer :account_number
      t.integer :representative_id
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
