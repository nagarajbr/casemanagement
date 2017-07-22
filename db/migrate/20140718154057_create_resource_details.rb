class CreateResourceDetails < ActiveRecord::Migration
  def change
    create_table :resource_details do |t|
      t.references :resource
      t.decimal :resource_value, precision: 8, scale: 2
      t.date :resource_valued_date
      t.decimal :first_of_month_value, precision: 8, scale: 2
      t.integer :res_value_basis
      t.decimal :res_ins_face_value, precision: 8, scale: 2
      t.decimal :amount_owned_on_resource, precision: 8, scale: 2
      t.date :amount_owned_as_of_date
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
