class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.references :client, index: true

        t.integer :phone_type
        t.string :number, limit: 10
        t.integer :created_by , null:false
        t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
